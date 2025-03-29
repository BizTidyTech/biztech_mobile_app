// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_controller/auth_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/widgets/input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final controller = Get.put(ProfileController());

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  String validator = '';

  attemptToChangePassword() async {
    if (oldPasswordController.text.trim().isNotEmpty == true &&
        newPasswordController.text.trim().isNotEmpty == true &&
        confirmNewPasswordController.text.trim().isNotEmpty == true) {
      if (newPasswordController.text.trim() ==
          confirmNewPasswordController.text.trim()) {
        final userData = await getLocallySavedUserDetails();
        if (oldPasswordController.text.trim() == userData?.password) {
          setState(() {
            validator = " ";
          });
          final newPassword = newPasswordController.text.trim();
          controller.changeUserPassword(context, newPassword);
        } else {
          setState(() {
            validator = "Old password incorrect";
          });
        }
      } else {
        setState(() {
          validator = "New passwords do not match";
        });
      }
    } else {
      setState(() {
        validator = "Kindly fill all fields to continue";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
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
          AppStrings.changePassword,
          style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
        ),
      ),
      body: GetBuilder<AuthController>(
        init: AuthController(),
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                inputWidget(
                  titleText: AppStrings.oldPassword,
                  textEditingController: oldPasswordController,
                  hintText: 'Enter your old password',
                  isObscurable: true,
                ),
                inputWidget(
                  titleText: AppStrings.newPassword,
                  textEditingController: newPasswordController,
                  hintText: 'Enter your new password',
                  isObscurable: true,
                ),
                inputWidget(
                  titleText: AppStrings.confirmNewPassword,
                  textEditingController: confirmNewPasswordController,
                  hintText: 'Confirm your new password',
                  textInputAction: TextInputAction.done,
                  isObscurable: true,
                ),
                verticalSpacer(40),
                Center(
                  child: Text(
                    validator,
                    style: AppStyles.normalStringStyle(13, AppColors.coolRed),
                  ),
                ),
                verticalSpacer(10),
                controller.showLoading == true
                    ? loadingWidget()
                    : CustomButton(
                        buttonText: AppStrings.save,
                        onPressed: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          attemptToChangePassword();
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
