// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:biztidy_mobile_app/app/helpers/agent_sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/agent_firebase_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_auth/agent_auth_model/agent_model.dart';
import 'package:biztidy_mobile_app/ui/features_agent/agent_jobs/agent_jobs_model/agent_job_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AgentHomeController extends GetxController {
  AgentModel? agentData;
  List<AgentJobModel> allJobs = [];
  StreamSubscription? _jobsSubscription;

  bool showLoading = false;
  String errMessage = '';

  @override
  void onInit() {
    super.onInit();
    loadAgentData();
  }

  @override
  void onClose() {
    _jobsSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadAgentData() async {
    showLoading = true;
    update();
    agentData = await getLocallySavedAgentDetails();
    if (agentData?.agentId != null) {
      _listenToJobs();
    }
    showLoading = false;
    update();
  }

  void _listenToJobs() {
    _jobsSubscription = AgentFirebaseService()
        .listenToAgentJobs(agentData!.agentId!)
        .listen((jobs) {
      allJobs = jobs;
      update();
    });
  }

  // Jobs filtered by status
  List<AgentJobModel> get pendingJobs =>
      allJobs.where((j) => j.status == 'pending').toList();

  List<AgentJobModel> get activeJobs =>
      allJobs.where((j) => j.status == 'in_progress').toList();

  List<AgentJobModel> get completedJobs =>
      allJobs.where((j) => j.status == 'completed').toList();

  bool get isOnline => agentData?.status == 'online' || agentData?.status == 'on_job';

  Future<void> toggleOnlineStatus() async {
    if (agentData == null) return;
    final newStatus = isOnline ? 'offline' : 'online';
    final success = await AgentFirebaseService()
        .updateAgentStatus(agentData!.agentId!, newStatus);
    if (success) {
      agentData = agentData!.copyWith(status: newStatus);
      await saveAgentDetailsLocally(agentData!);
      Fluttertoast.showToast(
        msg: isOnline ? 'You are now Online' : 'You are now Offline',
      );
      update();
    }
  }

  Future<void> acceptJob(AgentJobModel job) async {
    final updated = job.copyWith(
      status: 'accepted',
      assignedAt: DateTime.now(),
    );
    final success = await AgentFirebaseService().updateAgentJob(updated);
    if (success) {
      logger.i('Job accepted: ${job.jobId}');
      update();
    }
  }

  Future<void> declineJob(AgentJobModel job) async {
    final updated = job.copyWith(status: 'cancelled');
    await AgentFirebaseService().updateAgentJob(updated);
    update();
  }

  Future<void> signOut(BuildContext context) async {
    // Set offline before signing out
    if (agentData?.agentId != null) {
      await AgentFirebaseService()
          .updateAgentStatus(agentData!.agentId!, 'offline');
    }
    await clearAgentDetailsLocally();
    context.go('/');
  }
}
