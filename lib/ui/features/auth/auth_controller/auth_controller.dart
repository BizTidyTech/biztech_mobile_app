// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_logger.i

import 'dart:io';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features/auth/auth_utils/auth_utils.dart';
import 'package:tidytech/utils/extension_and_methods/string_cap_extensions.dart';

class AuthController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  UserData? userEnteredData;

  AuthController();

  bool showLoading = false, invalidOtp = false, isObscured = true;
  String errMessage = '';

  File? imageFile;

  disposeAllControllers() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    resetValues();
  }

  void resetValues() {
    errMessage = "";
    showLoading = false;
    invalidOtp = false;
    imageFile = null;
    userEnteredData = null;
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

  Future<void> attemptToVerifyNewUser(BuildContext context) async {
    logger.i('attemptToVerifyNewUser . . .');

    if (fullnameController.text.trim().isEmpty == true ||
        emailController.text.trim().isEmpty == true ||
        passwordController.text.trim().isEmpty == true ||
        confirmPasswordController.text.trim().isEmpty == true) {
      errMessage = 'All fields must be filled accordingly';
      update();
    } else if (await validateEmail(emailController.text.trim()) == false) {
      errMessage = 'Enter a valid email address';
      update();
    } else if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      errMessage = "Passwords do not match";
      update();
    } else {
      userEnteredData = UserData(
        userId: generateRandomString(),
        email: emailController.text.trim(),
        name: fullnameController.text.trim(),
        password: passwordController.text.trim(),
      );
      logger.i('Registering user . . . ${userEnteredData?.toJson()}');
      sendEmailOtp(context);
    }
  }

  Future<void> sendEmailOtp(BuildContext context, {bool? navigate}) async {
    startLoading();
    logger.i("Sending OTP . . .");
    final sendOtpResponse = await EmailOTP.sendOTP(email: emailController.text);
    if (sendOtpResponse == true) {
      logger.f("OTP sent successfully");
      navigate != false
          ? context.push('/verifyOtpScreen')
          : Fluttertoast.showToast(msg: "OTP has been resent");
    } else {
      logger.e("Error sending OTP");
      errMessage = 'Error sending OTP. Check email and try again';
    }
    stopLoading();
  }

  Future<void> verifyOtp(BuildContext context) async {
    startLoading();
    final verifyOtpResponse = EmailOTP.verifyOTP(otp: otpController.text);
    if (verifyOtpResponse == true) {
      Fluttertoast.showToast(msg: "Email verification successful");
      createNewUser(context);
    } else {
      invalidOtp = true;
      errMessage = 'Error verifying OTP';
      Fluttertoast.showToast(msg: 'Error verifying OTP');
      stopLoading();
    }
    otpController.clear();
    update();
  }

  createNewUser(BuildContext context) async {
    final isAccountCreated = await AuthUtil().createAccount(
      userEnteredData?.email ?? '',
      userEnteredData?.password ?? '',
    );
    if (isAccountCreated == true) {
      final isUserRegistered = await AuthUtil().registerUser(userEnteredData);
      if (isUserRegistered == true) {
        logger.f('Account created successfully.');
        await attemptToSignInUser(context);
      } else {
        errMessage = 'Error creating user.';
        logger.w('Error creating user.');
        stopLoading();
      }
    } else {
      errMessage = 'Error creating account.';
      logger.w('Error creating account.');
      stopLoading();
    }
  }

  Future<void> attemptToSignInUser(BuildContext context) async {
    logger.i('attemptToSignInUser . . .');
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      logger.i('signing in user . . .');
      startLoading();
      final isLoggedIn = await AuthUtil().signInUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (isLoggedIn == true) {
        logger.f("userEnteredData: ${userEnteredData?.toJson()}");
        await saveUserDetailsLocally(userEnteredData);
        context.go('/homepageView');
      }
    } else {
      errMessage = 'All fields must be filled, and with no spaces';
      logger.i("Errormessage: $errMessage");
      stopLoading();
    }
  }

  Future<void> updateNewUserData(BuildContext context) async {}

  /// Upload image from gallery
  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  /// Snap image with Camera
  getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }
}
