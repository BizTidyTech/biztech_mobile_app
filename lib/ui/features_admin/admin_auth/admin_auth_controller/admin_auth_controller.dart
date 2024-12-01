// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_logger.i

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tidytech/app/services/firebase_service.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features_admin/admin_auth/admin_auth_model/admin_data_model.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

class AdminAuthController extends GetxController {
  TextEditingController adminIdController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  AdminAuthModel? adminEnteredData;

  AdminAuthController();

  bool showLoading = false, invalidOtp = false, isObscured = true;
  String errMessage = '';

  File? imageFile;

  disposeAllControllers() {
    adminIdController.dispose();
    adminPasswordController.dispose();
    resetValues();
  }

  void resetValues() {
    errMessage = "";
    showLoading = false;
    invalidOtp = false;
    imageFile = null;
    adminEnteredData = null;
    update();
  }

  startLoading() {
    showLoading = true;
    errMessage = '';
    update();
  }

  stopLoading() {
    showLoading = false;
    update();
  }

  updateVals() {
    update();
  }

  toggleObscurePassword() {
    isObscured = !isObscured;
    logger.i("Toggling to $isObscured");
    update();
  }

  Future<void> attemptToSignInAdmin(BuildContext context) async {
    logger.i('attemptToSignInAdmin . . .');
    if (adminIdController.text.trim().isNotEmpty &&
        adminPasswordController.text.trim().isNotEmpty) {
      signInAdmin(
        context,
        adminIdController.text.trim(),
        adminPasswordController.text.trim(),
      );
    } else {
      errMessage = 'Both ID and password are required';
      logger.i("Errormessage: $errMessage");
      stopLoading();
    }
  }

  Future<void> signInAdmin(
      BuildContext context, String adminID, String adminPassword) async {
    logger.i('signing in admin . . .');
    errMessage = '';
    startLoading();
    final adminAuthData = await FirebaseService().getAdminAuthDetails();

    if (adminID == adminAuthData?.id &&
        adminPassword == adminAuthData?.password) {
      Fluttertoast.showToast(msg: "Logged in successfully");
      context.go('/adminBookingsListScreen');
    } else {
      errMessage = 'Incorrect ID and password';
      Fluttertoast.showToast(
        msg: "Incorrect credentials",
        backgroundColor: AppColors.coolRed,
      );
    }
    stopLoading();
  }
}
