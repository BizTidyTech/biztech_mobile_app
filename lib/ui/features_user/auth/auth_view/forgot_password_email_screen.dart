// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final controller = Get.put(AuthController());

  String validator = '';

  attemptToSendOtp() async {
    if (controller.emailController.text.trim().isNotEmpty == true) {
      setState(() {
        validator = " ";
      });
      controller.sendEmailOtp(context, isResetPassword: true);
    } else {
      setState(() {
        validator = "Kindly enter your email to continue";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plainWhite,
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppColors.plainWhite,
        backgroundColor: AppColors.plainWhite,
        surfaceTintColor: AppColors.plainWhite,
        centerTitle: true,
        title: Text(
          AppStrings.forgotPassword,
          style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
        ),
      ),
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // verticalSpacer(40),
                  inputWidget(
                    titleText: AppStrings.email,
                    textEditingController: controller.emailController,
                    hintText: 'Enter your email address',
                  ),
                  verticalSpacer(40),
                  Center(
                    child: Text(
                      validator,
                      style: AppStyles.subStringStyle(13, AppColors.coolRed),
                    ),
                  ),
                  verticalSpacer(10),
                  controller.showLoading == true
                      ? loadingWidget()
                      : CustomButton(
                          buttonText: AppStrings.contineu,
                          onPressed: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            attemptToSendOtp();
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
