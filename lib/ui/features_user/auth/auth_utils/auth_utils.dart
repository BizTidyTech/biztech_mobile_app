// ignore_for_file: avoid_print

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/push_notification_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthUtil {
  final auth = FirebaseAuth.instance;
  Future<bool> createAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Email address already in use.");
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: "Invalid email address.");
      } else {
        Fluttertoast.showToast(
            msg: "An error occurred while creating the account.");
      }
      return false;
    }
  }

  Future<bool> registerUser(UserData? userdata) async {
    UserData userData = UserData(
      userId: auth.currentUser!.uid,
      email: auth.currentUser!.email ?? userdata?.email,
      password: userdata?.password,
      name: auth.currentUser!.displayName ?? userdata?.name,
      photoUrl: auth.currentUser!.photoURL,
      country: userdata?.country,
      timeCreated: DateTime.now(),
    );
    bool isRegister = await FirebaseService().register(user: userData);
    return isRegister;
  }

  Future<bool> signInUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userData = await FirebaseService().getUserDetails(email: email);
      if (userData != null) {
        await saveUserDetailsLocally(userData);
        await initOneSignalPlatformState();
        OneSignal.login(userData.userId!);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      if (e.code == "invalid-credential") {
        Fluttertoast.showToast(
            msg: "Invalid credentials. Verify and try again");
      } else {
        Fluttertoast.showToast(msg: "Error occured! Please try again!");
      }
      return false;
    }
  }
}
