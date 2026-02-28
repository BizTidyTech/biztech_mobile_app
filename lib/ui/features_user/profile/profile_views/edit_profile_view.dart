// ignore_for_file: must_be_immutable, unused_element

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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.put(ProfileController());
  static const String nigeria = "Nigeria", usa = "USA";
  String _selectedCountry = nigeria;

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
    _selectedCountry = controller.myProfileData?.country ?? nigeria;
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
                      hintText: 'Enter your phone number',
                    ),
                    profileInputWidget(
                      titleText: "Address",
                      textEditingController: controller.addressController,
                      hintText: 'Enter your address',
                      textInputAction: TextInputAction.done,
                    ),
                    verticalSpacer(20),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Country",
                    //       style: AppStyles.subStringStyle(
                    //         12,
                    //         AppColors.fullBlack,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // _countrySelector(),
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
                              controller
                                  .attemptToUpdateProfileData(_selectedCountry);
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

  Widget _countrySelector() {
    return RadioGroup<String>(
      groupValue: _selectedCountry,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedCountry = value;
          });
        }
      },
      child: Column(
        children: [
          // Nigeria option.
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            minVerticalPadding: 0,
            minTileHeight: 30,
            leading: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.network(
                'https://upload.wikimedia.org/wikipedia/commons/7/79/Flag_of_Nigeria.svg',
                width: 40,
                height: 40,
              ),
            ),
            title: Text(
              nigeria,
              style: AppStyles.regularStringStyle(15, AppColors.fullBlack),
            ),
            trailing: Radio<String>(
              activeColor: Colors.blue,
              value: nigeria,
            ),
            onTap: () {
              setState(() {
                _selectedCountry = nigeria;
              });
            },
          ),
          // USA option.
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            minVerticalPadding: 0,
            minTileHeight: 30,
            leading: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.network(
                'https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg',
                width: 40,
                height: 40,
              ),
            ),
            title: Text(
              usa,
              style: AppStyles.regularStringStyle(15, AppColors.fullBlack),
            ),
            trailing: Radio<String>(
              activeColor: Colors.blue,
              value: usa,
            ),
            onTap: () {
              setState(() {
                _selectedCountry = usa;
              });
            },
          ),
        ],
      ),
    );
  }
}
