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
    errMessage = '';

    if (fullnameController.text.trim().isNotEmpty &&
        !fullnameController.text.trim().contains(" ") &&
        passwordController.text.trim().isNotEmpty &&
        !passwordController.text.trim().contains(" ")) {
      print('signing in user . . .');
      showLoading = true;
      errMessage = '';
      update();
      checkIfUserExistsForSignIn(context);
    } else {
      errMessage = 'All fields must be filled, and with no spaces';
      print("Errormessage: $errMessage");
      showLoading = false;
      update();
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

  void attemptToRegisterUser(BuildContext context) {
    print('attemptToRegisterUser . . .');
    errMessage = '';
    showLoading = true;
    update();

    if (fullnameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty) {
      print('Registering user . . .');
      showLoading = true;
      errMessage = '';
      update();
      checkIfUserExistsForCreateAccount(context);
    } else {
      errMessage = 'All fields must be filled, and with no spaces';
      print("Errormessage: $errMessage");
      showLoading = false;
      update();
    }
  }

  Future<void> checkIfUserExistsForCreateAccount(BuildContext context) async {
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
          "UserAccountModel: ${userAccountModel.toJson()} \nUsername: ${userAccountModel.username}");

      userExisting = usernameController.text.trim();
      showLoading = false;
      update();
      context.pushReplacement('/signInExistingUserView');
    } else {
      print('User does not exist. Creating new user . . .');
      registerUser(context);
    }
    */
  }

  Future<void> registerUser(BuildContext context) async {
    /*
    UserAccountModel createAccountData = UserAccountModel()
      ..username = usernameController.text.trim()
      ..password = passwordController.text.trim()
      ..totalPoints = 0
      ..totalToponymsRecorded = 0
      ..naturalToponymsRecorded = 0
      ..artificialToponymsRecorded = 0;

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("user_details/${createAccountData.username}");

    print(createAccountData.toJson());

    await ref
        .set(createAccountData.toJson())
        .whenComplete(
          () => showCustomSnackBar(
              context,
              "User ${usernameController.text.trim()} created",
              () {},
              Colors.green,
              1000),
        )
        .whenComplete(() async {
      GlobalVariables.myUsername = usernameController.text.trim();
      print("GlobalVariables.myUsername: ${GlobalVariables.myUsername}");
      errMessage = " ";
      showLoading = false;
      update();
      context.pushReplacement('/updateNewAccountView');
    });
    */
  }

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

  Future<void> updateNewUserData(BuildContext context) async {
    /*
    if (countrySelected != ' ' &&
        stateSelected != ' ' &&
        citySelected != ' ' &&
        imageFile != null) {
      errMessage = '';
      showLoading = true;
      update();

      /// Upload image to cloud storage
      final firebaseStorage = FirebaseStorage.instance;
      var file = File(imageFile!.path);
      var snapshot = await firebaseStorage
          .ref()
          .child('tidytech/user_profile_images/${GlobalVariables.myUsername}')
          .putFile(file);

      /// Generate download
      var downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl = downloadUrl;

      UserAccountModel updateAccountData = UserAccountModel();

      final getDataRef = FirebaseDatabase.instance.ref();
      final getDataSnapshot = await getDataRef
          .child('user_details/${usernameController.text.trim()}')
          .get();
      if (getDataSnapshot.exists) {
        print("User exists: ${getDataSnapshot.value}");
        UserAccountModel userAccountModel = userAccountModelFromJson(
            jsonEncode(getDataSnapshot.value).toString());
        userAccountModel
          ..city = citySelected
          ..country = countrySelected
          ..profileImageLink = imageUrl;
        log.w("userAccountModel: ${userAccountModel.toJson()}");

        updateAccountData = userAccountModel;
        update();
      }
      log.wtf("updateAccountData: ${updateAccountData.toJson()}");

      DatabaseReference ref = FirebaseDatabase.instance
          .ref("user_details/${GlobalVariables.myUsername}");

      print(updateAccountData.toJson());

      await ref
          .update(updateAccountData.toJson())
          .whenComplete(
            () => showCustomSnackBar(
              context,
              "User ${usernameController.text.trim()} updated",
              () {},
              Colors.green,
              1000,
            ),
          )
          .whenComplete(() => gotoHomepage(context));
    } else {
      errMessage = "Ensure all fields are filled";
      update();
    }
    */
  }
}
