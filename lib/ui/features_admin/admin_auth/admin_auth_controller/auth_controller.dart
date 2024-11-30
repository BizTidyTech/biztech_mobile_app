// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_logger.i

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features_admin/admin_auth/admin_auth_model/admin_data_model.dart';
import 'package:tidytech/ui/features_user/auth/auth_utils/auth_utils.dart';

class AdminAuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AdminAuthModel? adminEnteredData;

  AdminAuthController();

  bool showLoading = false, invalidOtp = false, isObscured = true;
  String errMessage = '';

  File? imageFile;

  disposeAllControllers() {
    emailController.dispose();
    passwordController.dispose();
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
    logger.i('attemptToSignInUser . . .');
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      signInAdmin(
        context,
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      errMessage = 'Both username and password are required';
      logger.i("Errormessage: $errMessage");
      stopLoading();
    }
  }

  Future<void> signInAdmin(
      BuildContext context, String email, String password) async {
    logger.i('signing in user . . .');
    startLoading();
    final isLoggedIn = await AuthUtil().signInUser(email, password);
    if (isLoggedIn == true) {
      context.go('/adminBookingsListScreen');
    }
    stopLoading();
  }
}
