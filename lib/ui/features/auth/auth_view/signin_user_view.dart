// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tidytech/ui/features/auth/auth_controller/auth_controller.dart';
import 'package:tidytech/ui/features/auth/auth_view/widgets/input_widget.dart';
import 'package:tidytech/ui/features/auth/auth_view/widgets/top_card.dart';
import 'package:tidytech/ui/shared/custom_button.dart';
import 'package:tidytech/ui/shared/loading_widget.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';

class SignInUserView extends StatelessWidget {
  SignInUserView({super.key});

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (_) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: SizedBox(
                    child: Column(
                      children: [
                        authScreensTopCard(context, AppStrings.login),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              verticalSpacer(40),
                              inputWidget(
                                titleText: AppStrings.email,
                                textEditingController:
                                    controller.emailController,
                                hintText: 'Enter your email address',
                              ),
                              inputWidget(
                                titleText: AppStrings.password,
                                textEditingController:
                                    controller.passwordController,
                                hintText: 'Enter your password',
                              ),
                              verticalSpacer(40),
                              Center(
                                child: Text(controller.errMessage,
                                    style: AppStyles.subStringStyle(
                                        13, AppColors.coolRed)),
                              ),
                              verticalSpacer(10),
                              controller.showLoading == true
                                  ? loadingWidget()
                                  : CustomButton(
                                      buttonText: AppStrings.login,
                                      onPressed: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        controller.attemptToSignInUser(context);
                                      },
                                    ),
                              verticalSpacer(12),
                              controller.showLoading == true
                                  ? const SizedBox.shrink()
                                  : RichText(
                                      text: TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style: TextStyle(
                                          color: AppColors.fullBlack,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: AppStrings.signUp,
                                            style: AppStyles.regularStringStyle(
                                                14, AppColors.kPrimaryColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                controller.resetValues();
                                                context.pushReplacement(
                                                    '/createAccountView');
                                              },
                                          ),
                                        ],
                                      ),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
