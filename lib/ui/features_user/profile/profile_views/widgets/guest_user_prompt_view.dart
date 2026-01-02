import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget guestUserPromptView(BuildContext context, String section) {
  return Container(
    // height: 200,
    padding: const EdgeInsets.symmetric(vertical: 10),
    width: screenWidth(context),
    child: Column(
      children: [
        Text(
          "Sign in to see your $section",
          style: AppStyles.regularStringStyle(
            16,
            AppColors.fullBlack,
          ),
        ),
        verticalSpacer(35),
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
        verticalSpacer(15),
      ],
    ),
  );
}
