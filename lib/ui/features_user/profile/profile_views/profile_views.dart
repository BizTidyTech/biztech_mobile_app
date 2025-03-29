import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/change_password_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/edit_profile_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/help_center_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/web_data_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/image_full_screen_view.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.plainWhite,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.plainWhite,
        ),
        child: GetBuilder<ProfileController>(
          init: ProfileController(),
          initState: (state) {
            controller.getUserProfileData();
          },
          builder: (_) {
            return Scaffold(
              backgroundColor: AppColors.plainWhite,
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 3),
              appBar: AppBar(
                elevation: 3,
                automaticallyImplyLeading: false,
                centerTitle: true,
                shadowColor: AppColors.lightGray,
                surfaceTintColor: AppColors.plainWhite,
                backgroundColor: AppColors.plainWhite,
                title: Text(
                  AppStrings.profile,
                  style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
                ),
              ),
              extendBodyBehindAppBar: true,
              body: Container(
                height: screenHeight(context),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      verticalSpacer(
                          MediaQuery.of(context).viewPadding.top + 55),
                      _profileDetailsCard(),
                      verticalSpacer(20),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.user,
                        titleText: 'Personal  Details',
                        onPressed: () {
                          logger.i("Pressed Personal Details");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const EditProfileView();
                              },
                            ),
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: Icons.perm_contact_calendar_outlined,
                        titleText: 'Help Center',
                        onPressed: () {
                          logger.i("Pressed Help Center");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HelpCenterView();
                              },
                            ),
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: CupertinoIcons.question_circle,
                        titleText: 'About',
                        onPressed: () {
                          logger.i("Pressed About");
                          goToWebViewPage(
                            context,
                            title: "About us",
                            url: aboutUsUrl,
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: CupertinoIcons.doc_append,
                        titleText: 'Terms of Use',
                        onPressed: () {
                          logger.i("Pressed Terms of Use");
                          goToWebViewPage(
                            context,
                            title: "Terms of Use",
                            url: termsOfUseUrl,
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: CupertinoIcons.info_circle,
                        titleText: 'Disclaimer',
                        onPressed: () {
                          logger.i("Pressed Disclaimer");
                          goToWebViewPage(
                            context,
                            title: "Disclaimer",
                            url: disclaimerUrl,
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: CupertinoIcons.person_2_square_stack,
                        titleText: 'Privacy Policy',
                        onPressed: () {
                          logger.i("Pressed Privacy Policy");
                          goToWebViewPage(
                            context,
                            title: "Privacy Policy",
                            url: privacyPolicyUrl,
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.security_safe,
                        titleText: 'Change Password',
                        onPressed: () {
                          logger.i("Pressed 'Change Password");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ChangePasswordView();
                              },
                            ),
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.logout_1,
                        titleText: 'Logout',
                        color: AppColors.deepBlue,
                        showTrailingIcon: false,
                        onPressed: () {
                          logger.w("Pressed Logout");
                          showLogoutConfirmationSheet(context);
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.user_remove,
                        titleText: 'Delete Account',
                        color: AppColors.coolRed,
                        showTrailingIcon: false,
                        onPressed: () {
                          logger.w("Pressed Delete Account");
                          showDeleteAccountConfirmationSheet(context);
                        },
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

  showLogoutConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          height: 180,
          width: screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: AppColors.plainWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Log out?",
                style: AppStyles.regularStringStyle(
                    18, AppColors.primaryThemeColor),
              ),
              verticalSpacer(10),
              Text(
                "Confirm you want to log out from this account",
                textAlign: TextAlign.center,
                style: AppStyles.normalStringStyle(15, AppColors.fullBlack),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    color: AppColors.lighterGray,
                    borderColor: AppColors.regularGray,
                    height: 35,
                    width: 100,
                    child: Text(
                      "Cancel",
                      style: AppStyles.normalStringStyle(
                        16,
                        AppColors.fullBlack,
                      ),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  CustomButton(
                    height: 35,
                    color: AppColors.kPrimaryColor,
                    borderColor: AppColors.primaryThemeColor,
                    width: 100,
                    child: Text(
                      "Logout",
                      style: AppStyles.normalStringStyle(
                        16,
                        AppColors.fullBlack,
                      ),
                    ),
                    onPressed: () async {
                      controller.logout(context);
                      context.go('/onboardingScreen');
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  showDeleteAccountConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          height: 180,
          width: screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: AppColors.plainWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Delete Account?",
                style: AppStyles.regularStringStyle(18, AppColors.coolRed),
              ),
              verticalSpacer(10),
              Text(
                "Confirm you want to permanently delete this account",
                textAlign: TextAlign.center,
                style: AppStyles.normalStringStyle(15, AppColors.fullBlack),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    color: AppColors.lighterGray,
                    borderColor: AppColors.regularGray,
                    height: 35,
                    width: 100,
                    child: Text(
                      "Cancel",
                      style: AppStyles.normalStringStyle(
                        16,
                        AppColors.fullBlack,
                      ),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  CustomButton(
                    height: 35,
                    color: AppColors.coolRed,
                    borderColor: AppColors.coolRed,
                    width: 100,
                    child: Text(
                      "Delete",
                      style:
                          AppStyles.normalStringStyle(16, AppColors.fullBlack),
                    ),
                    onPressed: () async {
                      await controller.deleteAccount(context);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _profileDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 125,
      width: screenWidth(context),
      child: controller.showLoading == true
          ? loadingWidget()
          : Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    InkWell(
                      onTap: () {
                        logger.w("Show profile image in full screen");
                        if (controller.myProfileData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ImageFullScreen(
                                  userData: controller.myProfileData!,
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 51,
                        backgroundColor: AppColors.primaryThemeColor,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            controller.myProfileData?.photoUrl ?? dummyImageUrl,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        logger.w("Change profile image");
                        controller.changeProfileImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryThemeColor,
                        radius: 18.5,
                        child: CircleAvatar(
                          backgroundColor: AppColors.plainWhite,
                          radius: 18,
                          child: Icon(
                            IconsaxPlusLinear.gallery_edit,
                            size: 20,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                horizontalSpacer(15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.myProfileData?.name ?? '',
                        style: AppStyles.normalStringStyle(
                            17, AppColors.fullBlack),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        controller.myProfileData?.email ?? '',
                        style: AppStyles.hintStringStyle(14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpacer(5),
                      const Divider(height: 1, thickness: 1)
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _profileOptionsCard({
    required IconData leadingIcon,
    bool? showTrailingIcon,
    required String titleText,
    Color? color,
    required final void Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 65,
        width: screenWidth(context),
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  leadingIcon,
                  color: color ?? AppColors.fullBlack,
                ),
                horizontalSpacer(15),
                Text(
                  titleText,
                  style: AppStyles.normalStringStyle(
                      17, color ?? AppColors.fullBlack),
                ),
                const Spacer(),
                showTrailingIcon == false
                    ? const SizedBox.shrink()
                    : Icon(
                        IconsaxPlusLinear.arrow_right_3,
                        color: AppColors.fullBlack,
                        size: 25,
                      ),
              ],
            ),
            verticalSpacer(10),
            const Divider(height: 2, thickness: 2)
          ],
        ),
      ),
    );
  }
}
