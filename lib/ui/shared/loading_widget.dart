import 'package:flutter/material.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

Widget loadingWidget() {
  return Center(
    child: CircularProgressIndicator(
      color: AppColors.primaryThemeColor,
      strokeWidth: 3,
    ),
  );
}
