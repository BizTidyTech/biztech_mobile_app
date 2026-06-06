import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/top_card.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    controller.otpController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        body: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (_) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    authScreensTopCard(context, AppStrings.emailVerification),
                    verticalSpacer(42),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: AppStrings.emailVerificationText,
                          style:
                              AppStyles.subStringStyle(14, AppColors.fullBlack),
                          children: <TextSpan>[
                            TextSpan(
                                text: controller.userEnteredData?.email,
                                style: AppStyles.regularStringStyle(
                                    14, AppColors.primaryThemeColor)),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacer(49),
                    Center(
                      child: SizedBox(
                        width: 280,
                        child: PinCodeTextField(
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 50,
                            fieldWidth: 36,
                            activeColor: AppColors.deepBlue,
                            activeFillColor: AppColors.plainWhite,
                            selectedColor: AppColors.normalGreen,
                            selectedFillColor: AppColors.plainWhite,
                            inactiveColor: AppColors.kPrimaryColor,
                            inactiveFillColor: AppColors.plainWhite,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: AppColors.transparent,
                          enableActiveFill: true,
                          controller: controller.otpController,
                          keyboardType: TextInputType.number,
                          onCompleted: (value) {
                            controller.verifyOtp(context);
                          },
                          onChanged: (value) {
                            setState(() {});
                          },
                          beforeTextPaste: (text) {
                            return false;
                          },
                          appContext: context,
                        ),
                      ),
                    ),
                    verticalSpacer(24),
                    controller.showLoading == true
                        ? loadingWidget()
                        : RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '',
                              children: <TextSpan>[
                                controller.invalidOtp == true
                                    ? TextSpan(
                                        text: "Invalid OTP.   ",
                                        style: AppStyles.subStringStyle(
                                            14, AppColors.coolRed),
                                      )
                                    : TextSpan(
                                        text: 'Didn\'t receive any code?   ',
                                        style: AppStyles.subStringStyle(
                                            14, AppColors.fullBlack),
                                      ),
                                TextSpan(
                                  text: 'Resend',
                                  style: AppStyles.subStringStyle(
                                      14, AppColors.primaryThemeColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      controller.sendEmailOtp(context,
                                          navigate: false);
                                    },
                                ),
                              ],
                            ),
                          ),
                    verticalSpacer(10),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
