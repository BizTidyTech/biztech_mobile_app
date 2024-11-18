import 'package:flutter/material.dart';
import 'package:tidytech/ui/shared/custom_textfield_.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';

Widget inputWidget(
    {required String titleText,
    required TextEditingController textEditingController,
    required String hintText}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    height: 79,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppStyles.subStringStyle(
            12,
            AppColors.fullBlack,
          ),
        ),
        CustomTextfield(
          textEditingController: textEditingController,
          hintText: hintText,
        ),
      ],
    ),
  );
}
