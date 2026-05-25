import 'package:biztidy_mobile_app/ui/features_agent/agent_auth/agent_auth_controller/agent_auth_controller.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AgentCreateAccountView extends StatefulWidget {
  const AgentCreateAccountView({super.key});

  @override
  State<AgentCreateAccountView> createState() => _AgentCreateAccountViewState();
}

class _AgentCreateAccountViewState extends State<AgentCreateAccountView> {
  final controller = Get.put(AgentAuthController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: GetBuilder<AgentAuthController>(
          builder: (_) {
            return Scaffold(
              backgroundColor: AppColors.plainWhite,
              appBar: AppBar(
                backgroundColor: AppColors.primaryThemeColor,
                iconTheme: IconThemeData(color: AppColors.plainWhite),
                title: Text('Agent Application',
                    style:
                        AppStyles.keyStringStyle(18, AppColors.plainWhite)),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacer(10),
                    Text(
                      'Create Your Agent Account',
                      style: AppStyles.keyStringStyle(20, AppColors.fullBlack),
                    ),
                    verticalSpacer(6),
                    Text(
                      'Fill in your details below. Your application will be reviewed and approved before you can start receiving jobs.',
                      style: AppStyles.subStringStyle(13, AppColors.darkGray),
                    ),
                    verticalSpacer(24),
                    _label('Full Name'),
                    _field(controller.signupNameController, 'Enter your full name'),
                    verticalSpacer(16),
                    _label('Email Address'),
                    _field(controller.signupEmailController, 'Enter your email',
                        type: TextInputType.emailAddress),
                    verticalSpacer(16),
                    _label('Phone Number'),
                    _field(controller.signupPhoneController, 'e.g. +2348012345678',
                        type: TextInputType.phone),
                    verticalSpacer(16),
                    _label('Home Address'),
                    _field(controller.signupAddressController,
                        'Enter your address (optional)'),
                    verticalSpacer(16),
                    _label('Password'),
                    _passwordField(
                      controller: controller.signupPasswordController,
                      hint: 'Create a password',
                      isObscured: controller.isSignupObscured,
                      onToggle: controller.toggleSignupObscure,
                    ),
                    verticalSpacer(16),
                    _label('Confirm Password'),
                    _field(controller.signupConfirmPasswordController,
                        'Confirm your password',
                        obscure: true),
                    verticalSpacer(20),
                    if (controller.errMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          controller.errMessage,
                          style: AppStyles.subStringStyle(
                              13, AppColors.coolRed),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    controller.showLoading
                        ? Center(child: loadingWidget())
                        : CustomButton(
                            buttonText: 'Submit Application',
                            width: screenWidth(context),
                            onPressed: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              controller.attemptSignUp(context);
                            },
                          ),
                    verticalSpacer(16),
                    Center(
                      child: RichText(
                        textScaler: const TextScaler.linear(1),
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: AppStyles.subStringStyle(
                              14, AppColors.fullBlack),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: AppStyles.regularStringStyle(
                                  14, AppColors.primaryThemeColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  controller.resetValues();
                                  context.pushReplacement('/agentSignInView');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacer(30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style:
                AppStyles.regularStringStyle(14, AppColors.fullBlack)),
      );

  Widget _field(TextEditingController ctrl, String hint,
      {TextInputType? type, bool obscure = false}) =>
      TextField(
        controller: ctrl,
        keyboardType: type,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppStyles.subStringStyle(14, AppColors.darkGray),
          filled: true,
          fillColor: AppColors.lighterGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscured,
    required VoidCallback onToggle,
  }) =>
      TextField(
        controller: controller,
        obscureText: isObscured,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppStyles.subStringStyle(14, AppColors.darkGray),
          filled: true,
          fillColor: AppColors.lighterGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off : Icons.visibility,
              color: AppColors.darkGray,
            ),
            onPressed: onToggle,
          ),
        ),
      );
}
