// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/agent_sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/agent_firebase_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_model/agent_job_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AgentJobsController extends GetxController {
  AgentJobModel? selectedJob;
  bool showLoading = false;

  final ImagePicker _picker = ImagePicker();
  List<String> beforePhotoUrls = [];
  List<String> afterPhotoUrls = [];
  bool uploadingPhotos = false;

  void selectJob(AgentJobModel job) {
    selectedJob = job;
    beforePhotoUrls = List.from(job.beforePhotoUrls ?? []);
    afterPhotoUrls = List.from(job.afterPhotoUrls ?? []);
    update();
  }

  void startLoading() {
    showLoading = true;
    update();
  }

  void stopLoading() {
    showLoading = false;
    update();
  }

  Future<void> startJob() async {
    if (selectedJob == null) return;
    startLoading();
    final updated = selectedJob!.copyWith(
      status: 'in_progress',
      startedAt: DateTime.now(),
    );
    final success = await AgentFirebaseService().updateAgentJob(updated);
    if (success) {
      selectedJob = updated;
      // Also update agent status to on_job
      final agent = await getLocallySavedAgentDetails();
      if (agent?.agentId != null) {
        await AgentFirebaseService()
            .updateAgentStatus(agent!.agentId!, 'on_job');
      }
      Fluttertoast.showToast(
        msg: 'Job started! Upload before photos.',
      );
    }
    stopLoading();
  }

  Future<void> pickAndUploadPhoto({required bool isBefore}) async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (image == null) return;

      uploadingPhotos = true;
      update();

      final fileName =
          '${isBefore ? 'before' : 'after'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('job_photos')
          .child(selectedJob!.jobId!)
          .child(fileName);

      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      if (isBefore) {
        beforePhotoUrls.add(url);
        await AgentFirebaseService().uploadJobPhotos(
          jobId: selectedJob!.jobId!,
          photoUrls: beforePhotoUrls,
          isBefore: true,
        );
        selectedJob = selectedJob!.copyWith(beforePhotoUrls: beforePhotoUrls);
      } else {
        afterPhotoUrls.add(url);
        await AgentFirebaseService().uploadJobPhotos(
          jobId: selectedJob!.jobId!,
          photoUrls: afterPhotoUrls,
          isBefore: false,
        );
        selectedJob = selectedJob!.copyWith(afterPhotoUrls: afterPhotoUrls);
      }

      logger.i('Photo uploaded: $url');
      Fluttertoast.showToast(msg: 'Photo uploaded successfully');
    } catch (e) {
      logger.e(e);
      Fluttertoast.showToast(msg: 'Error uploading photo. Retry.');
    }
    uploadingPhotos = false;
    update();
  }

  Future<void> completeJob(BuildContext context) async {
    if (selectedJob == null) return;

    if (afterPhotoUrls.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please upload at least one after photo',
        backgroundColor: Colors.orange,
      );
      return;
    }

    startLoading();
    final updated = selectedJob!.copyWith(
      status: 'completed',
      completedAt: DateTime.now(),
      afterPhotoUrls: afterPhotoUrls,
    );
    final success = await AgentFirebaseService().updateAgentJob(updated);
    if (success) {
      selectedJob = updated;
      // Set agent back to online
      final agent = await getLocallySavedAgentDetails();
      if (agent?.agentId != null) {
        await AgentFirebaseService()
            .updateAgentStatus(agent!.agentId!, 'online');
      }
      Fluttertoast.showToast(
        msg: 'Job completed! Great work.',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    }
    stopLoading();
  }
}
