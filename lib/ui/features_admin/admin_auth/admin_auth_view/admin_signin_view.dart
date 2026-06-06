// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_controller/admin_auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_view/widgets/admin_input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/top_card.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/notifications_utils.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminSignInView extends StatefulWidget {
  const AdminSignInView({super.key});

  @override
  State<AdminSignInView> createState() => _AdminSignInViewState();
}

class _AdminSignInViewState extends State<AdminSignInView> {
  final controller = Get.put(AdminAuthController());

  @override
  void initState() {
    super.initState();
    initOneSignalPlatformState();
  }

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
        child: GetBuilder<AdminAuthController>(
          init: AdminAuthController(),
          builder: (_) {
            return Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    children: [
                      authScreensTopCard(context, AppStrings.adminLogin),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            verticalSpacer(40),
                            adminInputWidget(
                              titleText: AppStrings.adminIdText,
                              textEditingController:
                                  controller.adminIdController,
                              hintText: 'Enter admin ID',
                            ),
                            adminInputWidget(
                              titleText: AppStrings.password,
                              textEditingController:
                                  controller.adminPasswordController,
                              hintText: 'Enter password',
                              isObscurable: true,
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
                                    buttonText: AppStrings.adminLogin,
                                    onPressed: () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      controller.attemptToSignInAdmin(context);
                                    },
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
      ),
    );
  }
}
