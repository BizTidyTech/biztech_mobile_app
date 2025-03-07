import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
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
                  verticalSpacer(10),
                  const Spacer(),
                  Text(
                    "${AppStrings.welcome} ${AppStrings.to}",
                    style: AppStyles.subStringStyle(22, AppColors.fullBlack),
                  ),
                  Text(
                    AppStrings.tidyTechTitle,
                    style: AppStyles.defaultKeyStringStyle(32, 'Audiowide')
                        .copyWith(color: AppColors.fullBlack),
                  ),
                  verticalSpacer(5),
                  Text(
                    AppStrings.tidyTechSub,
                    style: AppStyles.regularStringStyle(17, AppColors.fullBlack,
                        family: 'Alice'),
                  ),
                  const Spacer(flex: 2),
                  Center(
                    child: CustomButton(
                      buttonText: AppStrings.signUp,
                      onPressed: () => context.push('/createAccountView'),
                    ),
                  ),
                  verticalSpacer(15),
                  Center(
                    child: CustomButton(
                      borderColor: AppColors.deepBlue,
                      color: AppColors.kPrimaryColor,
                      textcolor: AppColors.deepBlue,
                      buttonText: AppStrings.login,
                      onPressed: () => context.push('/signInUserView'),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
