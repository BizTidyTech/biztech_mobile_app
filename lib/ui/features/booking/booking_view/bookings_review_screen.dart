// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tidytech/ui/features/booking/booking_controller/booking_controller.dart';
import 'package:tidytech/ui/features/booking/booking_model/booking_model.dart';
import 'package:tidytech/ui/shared/curved_container.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';

class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  final controller = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      init: BookingsController(),
      builder: (_) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: AppBar(
              elevation: 3,
              shadowColor: AppColors.lightGray,
              surfaceTintColor: AppColors.plainWhite,
              backgroundColor: AppColors.plainWhite,
              title: Text(
                AppStrings.reviewDetails,
                style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CustomCurvedContainer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
