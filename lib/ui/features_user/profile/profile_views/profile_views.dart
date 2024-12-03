import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:tidytech/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:tidytech/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:tidytech/ui/features_user/profile/profile_views/edit_profile_view.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/app_constants/constants.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';

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
                      verticalSpacer(30),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.user,
                        titleText: 'Personal  Details',
                        onPressed: () {
                          logger.i("Pressed Personal Details");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfileView();
                              },
                            ),
                          );
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: CupertinoIcons.question_circle,
                        titleText: 'Help Center',
                        onPressed: () {
                          logger.i("Pressed Help Center");
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.info_circle,
                        titleText: 'About',
                        onPressed: () {
                          logger.i("Pressed About");
                        },
                      ),
                      _profileOptionsCard(
                        leadingIcon: IconsaxPlusLinear.logout_1,
                        titleText: 'Logout',
                        color: AppColors.coolRed,
                        showTrailingIcon: false,
                        onPressed: () {
                          logger.w("Pressed Logout");
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

  Widget _profileDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 125,
      width: screenWidth(context),
      child: Row(
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
                  style: AppStyles.normalStringStyle(17, AppColors.fullBlack),
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
        height: 70,
        width: screenWidth(context),
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        // color: AppColors.blueGray,
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

class ImageFullScreen extends StatelessWidget {
  final UserData userData;
  const ImageFullScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryThemeColor,
        title: Text(
          userData.name ?? '',
          style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
        ),
      ),
      backgroundColor: AppColors.fullBlack,
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context) -
            (MediaQuery.of(context).viewPadding.top + 55),
        decoration: BoxDecoration(
          color: AppColors.fullBlack,
          image: DecorationImage(
            image: CachedNetworkImageProvider(userData.photoUrl ?? ''),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
