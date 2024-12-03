// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/app/services/firebase_service.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

class ProfileController extends GetxController {
  ProfileController();
  String errMessage = '';
  bool showLoading = false;
  UserData? myProfileData;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  clearVals() {
    fullnameController.clear();
    addressController.clear();
    phoneController.clear();
    showLoading = false;
    errMessage = '';
    update();
  }

  getUserProfileData() async {
    startLoading();
    myProfileData = await getLocallySavedUserDetails();
    logger.f("myProfileData: ${myProfileData?.toJson()}");
    update();
  }

  attemptToUpdateProfileData() async {
    if (fullnameController.text.trim().isEmpty == true) {
      errMessage = "Full name field is required";
      Fluttertoast.showToast(msg: "Full name field is required");
    } else {
      await updateProfileData();
    }
  }

  updateProfileData() async {
    startLoading();
    try {
      final updatedUserProfile = myProfileData!.copyWith(
        name: fullnameController.text.trim(),
        address: addressController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );
      logger.f("updatedUserProfile: ${updatedUserProfile.toJson()}");
      final updated =
          await FirebaseService().updateUserProfile(updatedUserProfile);
      if (updated == true) {
        myProfileData = updatedUserProfile;
        saveUserDetailsLocally(updatedUserProfile);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating your profile",
        backgroundColor: AppColors.coolRed,
      );
    }
    stopLoading();
  }

  /// Upload image from gallery
  changeProfileImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final selectedImagefile = File(pickedFile.path);
      final profilePhotoUrl = await uploadProfilePhoto(selectedImagefile);
      if (profilePhotoUrl == null) {
        Fluttertoast.showToast(
            msg: "Error updating your profile photo. Kindly retry");
      } else {
        updateProfileWithPhotoUrl(profilePhotoUrl);
      }
    }
  }

/*
  Future<String?> uploadProfilePhoto(File selectedImagefile) async {
    startLoading();
    try {
      /// Upload image to cloud storage
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(selectedImagefile.path);
      var snapshot = await firebaseStorage
          .ref()
          .child('tidytech/profile_images/${myProfileData?.userId}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e("Error uploading image: ${e.toString()}");
    }
    stopLoading();
    return null;
  }
*/
  Future<String?> uploadProfilePhoto(File selectedImagefile) async {
    startLoading();
    try {
      final cloudinary = CloudinaryPublic(
        CloudinaryData.cloudName,
        CloudinaryData.uploadPreset,
        cache: false,
      );

      CloudinaryResponse uploadImageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          selectedImagefile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
        uploadPreset: CloudinaryData.uploadPreset,
      );
      logger.f("uploadImageResponse: ${uploadImageResponse.toMap()}");

      if (uploadImageResponse.assetId != '') {
        logger.f('Successfully uploaded the image: ${uploadImageResponse.url}');
        return uploadImageResponse.url;
      }
      return null;
    } catch (e) {
      logger.e("Error uploading image: ${e.toString()}");
    }
    stopLoading();
    return null;
  }

  updateProfileWithPhotoUrl(String photoUrl) async {
    startLoading();
    try {
      final updatedUserProfile = myProfileData!.copyWith(
        photoUrl: photoUrl,
      );
      logger.f("updatedUserProfile: ${updatedUserProfile.toJson()}");
      final updated =
          await FirebaseService().updateUserProfile(updatedUserProfile);
      if (updated == true) {
        myProfileData = updatedUserProfile;
        saveUserDetailsLocally(updatedUserProfile);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating your profile photo",
        backgroundColor: AppColors.coolRed,
      );
    }
    stopLoading();
  }

  startLoading() {
    showLoading = true;
    update();
  }

  stopLoading() {
    showLoading = false;
    update();
  }
}

class CloudinaryData {
  static String cloudName = "dujgin8k8";
  static String uploadPreset = "tidytech";
}

// ENIOLAsodiq5.