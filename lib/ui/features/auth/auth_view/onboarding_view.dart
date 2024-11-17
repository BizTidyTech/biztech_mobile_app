import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.kPrimaryColor,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Column(
          children: [
            verticalSpacer(60),
            const Spacer(),
            Container(
              height: screenHeight(context) * 0.36,
              width: screenWidth(context),
              decoration: const BoxDecoration(
                // color: AppColors.kPrimaryColor,
                image: DecorationImage(
                  image: AssetImage('assets/casual-life-cleaning.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: screenHeight(context) * 0.44,
              width: screenWidth(context),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacer(20),
                  Text(
                    "${AppStrings.welcome} ${AppStrings.to}",
                    style: AppStyles.subStringStyle(22, AppColors.fullBlack),
                  ),
                  Text(
                    AppStrings.tidyTechTitle,
                    style: AppStyles.defaultKeyStringStyle(32, 'Audiowide')
                        .copyWith(color: AppColors.fullBlack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
