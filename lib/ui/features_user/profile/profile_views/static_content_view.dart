import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

class StaticContentView extends StatelessWidget {
  final String title;
  final String content;
  const StaticContentView({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryThemeColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded,
              color: AppColors.fullBlack, size: 32),
        ),
        title: Text(title,
            style: AppStyles.normalStringStyle(20, AppColors.fullBlack)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: AppStyles.regularStringStyle(15, AppColors.fullBlack),
        ),
      ),
    );
  }
}