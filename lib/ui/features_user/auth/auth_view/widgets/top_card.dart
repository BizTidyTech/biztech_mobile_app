import 'package:flutter/material.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';

Widget authScreensTopCard(BuildContext context, String headerText) {
  return Container(
    height: 161,
    width: screenWidth(context),
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: AppColors.primaryThemeColor,
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(90)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacer(35),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.fullBlack,
            size: 35,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            headerText,
            style: AppStyles.regularStringStyle(20, AppColors.fullBlack),
          ),
        ),
      ],
    ),
  );
}
