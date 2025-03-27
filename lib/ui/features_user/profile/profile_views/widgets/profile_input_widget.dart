import 'package:biztidy_mobile_app/ui/shared/custom_textfield_.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget profileInputWidget({
  required String titleText,
  required TextEditingController textEditingController,
  required String hintText,
  TextInputAction? textInputAction = TextInputAction.next,
  TextInputType? keyboardType,
  bool? enabled,
  int? maxLines,
  int? minLines,
}) {
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
          hintStyle:
              AppStyles.hintStringStyle(12).copyWith(color: AppColors.deepBlue),
          textInputAction: textInputAction ?? TextInputAction.next,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          enabled: enabled ?? true,
          fillColor: AppColors.kPrimaryColor,
        ),
      ],
    ),
  );
}
