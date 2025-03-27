// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation? sizeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..forward();

    sizeAnimation = Tween(begin: 20.0, end: 50.0).animate(CurvedAnimation(
        parent: animationController!, curve: const Interval(0.0, 0.5)));

    animationController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        logger.f('Animation completed');
        sleep(const Duration(milliseconds: 200));
        await OneSignal.Notifications.requestPermission(true);

        final existingUserData = await getLocallySavedUserDetails();
        logger.w('existingUserData: ${existingUserData?.toJson()}');
        String? userEmail = existingUserData?.email;
        String? userPassword = existingUserData?.password;
        if (existingUserData != null &&
            userEmail != null &&
            userPassword != null) {
          AuthController().signInUser(context, userEmail, userPassword);
        } else {
          context.pushReplacement('/onboardingScreen');
        }
      }
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.blue,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: AnimateGradient(
          primaryBeginGeometry: const AlignmentDirectional(0, 1),
          primaryEndGeometry: const AlignmentDirectional(0, 2),
          secondaryBeginGeometry: const AlignmentDirectional(2, 0),
          secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
          textDirectionForGeometry: TextDirection.rtl,
          duration: const Duration(milliseconds: 500),
          primaryColors: [
            Colors.blueAccent,
            AppColors.primaryThemeColor,
            AppColors.kPrimaryColor,
            Colors.blueAccent,
            AppColors.primaryThemeColor,
            AppColors.kPrimaryColor,
          ],
          secondaryColors: [
            AppColors.kPrimaryColor,
            AppColors.primaryThemeColor,
            Colors.blueAccent,
            AppColors.kPrimaryColor,
            AppColors.primaryThemeColor,
            Colors.blueAccent,
          ],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.tidyTechTitle.toUpperCase(),
                  style: AppStyles.defaultKeyStringStyle(54, 'Audiowide'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.tidyTechCaption,
                      style: AppStyles.subStringStyle(12, AppColors.fullBlack),
                    ),
                    horizontalSpacer(20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
