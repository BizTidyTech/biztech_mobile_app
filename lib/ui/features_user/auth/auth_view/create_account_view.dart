// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/top_card.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/web_data_view.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final controller = Get.put(AuthController());
  bool? acceptedTnC = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (_) {
          return GestureDetector(
            onTap: () =>
                SystemChannels.textInput.invokeMethod('TextInput.hide'),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    authScreensTopCard(context, AppStrings.signUp),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpacer(40),
                          inputWidget(
                            titleText: AppStrings.fullName.toSentenceCase,
                            textEditingController:
                                controller.fullnameController,
                            hintText: 'Enter your name',
                          ),
                          inputWidget(
                            titleText: AppStrings.email,
                            textEditingController: controller.emailController,
                            hintText: 'Enter your email address',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          inputWidget(
                            titleText: AppStrings.password,
                            textEditingController:
                                controller.passwordController,
                            hintText: 'Enter your preferred password',
                            isObscurable: true,
                          ),
                          inputWidget(
                            titleText: AppStrings.confirmPassword,
                            textEditingController:
                                controller.confirmPasswordController,
                            hintText: 'Confirm your password',
                            textInputAction: TextInputAction.done,
                            isObscurable: true,
                          ),
                          verticalSpacer(30),
                          Center(
                            child: Text(
                              controller.errMessage,
                              style: AppStyles.subStringStyle(
                                13,
                                AppColors.coolRed,
                              ),
                            ),
                          ),
                          verticalSpacer(10),
                          controller.showLoading == true
                              ? const SizedBox.shrink()
                              : RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'By signing up, you accept the ',
                                    style: AppStyles.regularStringStyle(
                                        14, AppColors.fullBlack),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: AppStrings.termsOfUse,
                                        style: AppStyles.regularStringStyle(
                                            14, AppColors.kPrimaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            goToWebViewPage(
                                              context,
                                              title: AppStrings.termsOfUse,
                                              url: termsOfUseUrl,
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: " and ",
                                        style: AppStyles.regularStringStyle(
                                            14, AppColors.fullBlack),
                                      ),
                                      TextSpan(
                                        text: AppStrings.privacyPolicy,
                                        style: AppStyles.regularStringStyle(
                                            14, AppColors.kPrimaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            goToWebViewPage(
                                              context,
                                              title: AppStrings.privacyPolicy,
                                              url: privacyPolicyUrl,
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                  textScaler: const TextScaler.linear(1),
                                ),
                          verticalSpacer(10),
                          controller.showLoading == true
                              ? loadingWidget()
                              : CustomButton(
                                  buttonText: AppStrings.signUp,
                                  onPressed: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    controller.attemptToVerifyNewUser(context);
                                  },
                                ),
                          verticalSpacer(12),
                          controller.showLoading == true
                              ? const SizedBox.shrink()
                              : RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: AppColors.fullBlack,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: AppStrings.login,
                                        style: AppStyles.regularStringStyle(
                                            14, AppColors.kPrimaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            controller.resetValues();
                                            context.pushReplacement(
                                                '/signInUserView');
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
        },
      ),
    );
  }
}
