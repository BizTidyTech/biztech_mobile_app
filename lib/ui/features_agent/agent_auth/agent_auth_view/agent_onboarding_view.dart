import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AgentOnboardingView extends StatelessWidget {
  const AgentOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.kPrimaryColor,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Column(
          children: [
            verticalSpacer(60),
            const Spacer(),
            // Icon / illustration
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cleaning_services_rounded,
                size: 72,
                color: AppColors.primaryThemeColor,
              ),
            ),
            verticalSpacer(24),
            Text(
              'Become a BizTidy Agent',
              style: AppStyles.keyStringStyle(22, AppColors.fullBlack),
              textAlign: TextAlign.center,
            ),
            verticalSpacer(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Join our network of professional cleaning agents and earn on your own schedule.',
                style: AppStyles.subStringStyle(15, AppColors.darkGray),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Container(
              width: screenWidth(context),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                children: [
                  // Benefits
                  _benefitRow(Icons.schedule, 'Work on your own schedule'),
                  verticalSpacer(10),
                  _benefitRow(Icons.payments_outlined, 'Get paid weekly'),
                  verticalSpacer(10),
                  _benefitRow(Icons.verified_user_outlined, 'Vetted & trusted platform'),
                  verticalSpacer(28),
                  CustomButton(
                    buttonText: 'Apply to Become an Agent',
                    width: screenWidth(context),
                    onPressed: () => context.push('/agentCreateAccountView'),
                  ),
                  verticalSpacer(14),
                  CustomButton(
                    buttonText: 'I Already Have an Account',
                    width: screenWidth(context),
                    color: AppColors.kPrimaryColor,
                    borderColor: AppColors.deepBlue,
                    textcolor: AppColors.deepBlue,
                    onPressed: () => context.push('/agentSignInView'),
                  ),
                  verticalSpacer(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryThemeColor, size: 20),
        const SizedBox(width: 10),
        Text(text,
            style: AppStyles.regularStringStyle(14, AppColors.fullBlack)),
      ],
    );
  }
}
