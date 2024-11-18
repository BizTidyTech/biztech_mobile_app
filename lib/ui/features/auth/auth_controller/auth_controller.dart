// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';

class AuthController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthController();

  bool showLoading = false;
  String errMessage = '';

  File? imageFile;
  String? imageUrl;

  void resetValues() {
    errMessage = "";
    showLoading = false;
    imageFile = null;
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

  void gotoSignInUserPage(BuildContext context) {
    print('Going to sign in user page');
    resetValues();
    context.push('/signInUserView');
  }

  void gotoHomepage(BuildContext context) async {
    await saveSharedPrefsStringValue(
        "username", fullnameController.text.trim());
    await saveSharedPrefsStringValue("profileImageLink", imageUrl!);
    print('Going to homepage page');
    resetValues();
    context.go('/homepageView');
  }

  void attemptToSignInUser(BuildContext context) {
    print('attemptToSignInUser . . .');
    if (fullnameController.text.trim().isNotEmpty &&
        !fullnameController.text.trim().contains(" ") &&
        passwordController.text.trim().isNotEmpty &&
        !passwordController.text.trim().contains(" ")) {
      print('signing in user . . .');
      startLoading();
      checkIfUserExistsForSignIn(context);
    } else {
      errMessage = 'All fields must be filled, and with no spaces';
      print("Errormessage: $errMessage");
      stopLoading();
    }
  }

  Future<void> checkIfUserExistsForSignIn(BuildContext context) async {
    /*
    print('checking If User Exists');
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('user_details/${usernameController.text.trim()}').get();
    if (snapshot.exists) {
      print("User exists: ${snapshot.value}");
      UserAccountModel userAccountModel =
          userAccountModelFromJson(jsonEncode(snapshot.value).toString());
      print(
          "UserAccountModel: ${userAccountModel.toJson()} \nPassword Existing: ${userAccountModel.password}");
      if (userAccountModel.password == passwordController.text.trim()) {
        showLoading = false;
        update();
        GlobalVariables.myUsername = usernameController.text.trim();
        print("GlobalVariables.myUsername: ${GlobalVariables.myUsername}");
        context.pushReplacement('/updateNewAccountView');
      } else {
        print('Password does not match.');
        errMessage = "Error! username or password incorrect";
        showLoading = false;
        update();
      }
    } else {
      print('User data does not exist.');
      errMessage = "Error! User ${usernameController.text.trim()} not found";
      showLoading = false;
      update();
    }
    */
  }

  void attemptToRegisterNewUser(BuildContext context) {
    print('attemptToRegisterUser . . .');

    if (fullnameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty) {
      print('Registering user . . .');
      startLoading();
    } else {
      errMessage = 'All fields must be filled accordingly';
      print("Errormessage: $errMessage");
      showLoading = false;
      update();
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
