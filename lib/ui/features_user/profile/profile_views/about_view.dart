import 'package:flutter/material.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/app_constants/constants.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryThemeColor,
        title: Text(
          'About us',
          style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
        ),
      ),
      body: SizedBox(
        width: screenWidth(context),
        height: screenHeight(context) -
            (MediaQuery.of(context).viewPadding.top + 55),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Text(
            aboutText,
            style: AppStyles.normalStringStyle(
              14,
              AppColors.fullBlack,
            ),
          ),
        ),
      ),
    );
  }
}
