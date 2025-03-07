import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

Widget loadingWidget() {
  return Center(
    child: CircularProgressIndicator(
      color: AppColors.primaryThemeColor,
      strokeWidth: 3,
    ),
  );
}
