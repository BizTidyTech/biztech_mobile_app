// ignore_for_file: depend_on_referenced_packages

import 'package:biztidy_mobile_app/app/resources/app.locator.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  Firebase.initializeApp();
  configureEmailOtp();
  runApp(const TidyTechApp()); // To run the User app
  // runApp(const AdminTidyTechApp());  // To run the Admin app
}

void configureEmailOtp() {
  EmailOTP.config(
    appName: AppStrings.tidyTechTitle,
    otpType: OTPType.numeric,
    expiry: 600000,
    emailTheme: EmailTheme.v6,
    appEmail: 'verification@tidytech.com',
    otpLength: 6,
  );
}
