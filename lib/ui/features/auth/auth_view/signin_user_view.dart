// ignore_for_file: must_be_immutable

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tidytech/ui/features/auth/auth_controller/auth_controller.dart';
import 'package:tidytech/ui/shared/custom_button.dart';
import 'package:tidytech/ui/shared/custom_textfield_.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';

class SignInUserView extends StatelessWidget {
  SignInUserView({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.plainWhite,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: const Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextfield(
                textEditingController: controller.fullnameController,
                labelText: AppStrings.email,
                hintText: 'Enter your preferred username',
              ),
              verticalSpacer(20),
              CustomTextfield(
                textEditingController: controller.passwordController,
                labelText: AppStrings.password,
                hintText: 'Enter your password',
              ),
              verticalSpacer(20),
              Center(
                child: GetBuilder<AuthController>(
                  init: AuthController(),
                  builder: (_) {
                    return Text(
                      controller.errMessage,
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
              verticalSpacer(40),
              CustomButton(
                buttonText: AppStrings.login,
                onPressed: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  controller.attemptToSignInUser(context);
                },
              ),
              verticalSpacer(12),
              RichText(
                textScaler: TextScaler.noScaling,
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(
                    color: AppColors.fullBlack,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: AppStrings.signUp,
                      style: AppStyles.regularStringStyle(
                        14,
                        AppColors.kPrimaryColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          controller.resetValues();
                          context.pushReplacement('/createAccountView');
                        },
                    ),
                  ],
                ),
              ),
              verticalSpacer(40),
              GetBuilder<AuthController>(
                init: AuthController(),
                builder: (_) {
                  return Center(
                    child: controller.showLoading == true
                        ? Platform.isAndroid
                            ? const CircularProgressIndicator()
                            : const CupertinoActivityIndicator()
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
