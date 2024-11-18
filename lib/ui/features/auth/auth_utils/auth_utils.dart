// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tidytech/app/services/firebase_service.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';

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

  Future<bool> registerUser() async {
    var userId = auth.currentUser!.uid;
    var email = auth.currentUser!.email;
    var name = auth.currentUser!.displayName;
    var photoUrl = auth.currentUser!.photoURL;
    UserData userData = UserData(
      userId: userId,
      email: email,
      name: name,
      photoUrl: photoUrl,
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
