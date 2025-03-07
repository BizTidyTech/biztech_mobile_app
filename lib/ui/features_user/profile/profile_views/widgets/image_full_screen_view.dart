import 'package:biztidy_mobile_app/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
