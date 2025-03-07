// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/profile_input_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.emailController =
        TextEditingController(text: controller.myProfileData?.email);
    controller.fullnameController =
        TextEditingController(text: controller.myProfileData?.name);
    controller.phoneController =
        TextEditingController(text: controller.myProfileData?.phoneNumber);
    controller.addressController =
        TextEditingController(text: controller.myProfileData?.address);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (_) {
          return GestureDetector(
            onTap: () =>
                SystemChannels.textInput.invokeMethod('TextInput.hide'),
            child: Scaffold(
              appBar: AppBar(
                elevation: 3,
                centerTitle: true,
                shadowColor: AppColors.lightGray,
                surfaceTintColor: AppColors.plainWhite,
                backgroundColor: AppColors.plainWhite,
                title: Text(
                  AppStrings.editProfile,
                  style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpacer(10),
                    profileInputWidget(
                      titleText: AppStrings.fullName.toSentenceCase,
                      textEditingController: controller.fullnameController,
                      hintText: 'Enter your name',
                    ),
                    profileInputWidget(
                      titleText: AppStrings.email,
                      textEditingController: controller.emailController,
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                    ),
                    profileInputWidget(
                      titleText: "Phone number",
                      textEditingController: controller.phoneController,
                      hintText: 'Enter your phone number password',
                    ),
                    profileInputWidget(
                      titleText: "Address",
                      textEditingController: controller.addressController,
                      hintText: 'Enter your address',
                      textInputAction: TextInputAction.done,
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
                        ? loadingWidget()
                        : CustomButton(
                            buttonText: AppStrings.update,
                            onPressed: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              controller.attemptToUpdateProfileData();
                            },
                          ),
                    verticalSpacer(12),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
