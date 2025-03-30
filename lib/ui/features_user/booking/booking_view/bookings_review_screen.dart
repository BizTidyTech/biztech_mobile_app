// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/curved_container.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                  CustomCurvedContainer(
                    height: 350,
                    fillColor: AppColors.kPrimaryColor,
                    topPadding: 15,
                    leftPadding: 15,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 115,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _keyText(AppStrings.service),
                              _keyText("Deposit Cost"),
                              _keyText("Location"),
                              _keyText("Address"),
                              _keyText("Phone No"),
                              _keyText("Rooms"),
                              _keyText("Duration"),
                              _keyText("Date"),
                              _keyText("Time"),
                            ],
                          ),
                        ),
                        horizontalSpacer(8),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _valueText(
                                    "${widget.booking.service?.name ?? ''} Cleaning"),
                                // _valueText(
                                //     "\$${widget.booking.service?.baseCost ?? ''}"),
                                _valueText(controller.userCountry == 'USA'
                                    ? "\$${controller.depositBookingAmount}"
                                    : 'N${controller.depositBookingAmountInNaira}'),
                                _valueText(widget.booking.locationName ?? ''),
                                _valueText(
                                    widget.booking.locationAddress ?? ''),
                                _valueText(
                                    widget.booking.customer?.phoneNumber ?? ''),
                                _valueText("${widget.booking.rooms ?? ''}"),
                                _valueText(
                                    "${widget.booking.duration ?? ''} hours"),
                                _valueText(DateFormat('MMM d, y').format(
                                    widget.booking.dateTime ?? DateTime.now())),
                                _valueText(DateFormat('h:mm a').format(
                                    widget.booking.dateTime ?? DateTime.now())),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "You are to deposit a sum of ${controller.userCountry == 'USA' ? "\$${controller.depositBookingAmount}" : 'N${controller.depositBookingAmountInNaira}'} to confirm your booking.",
                    textAlign: TextAlign.center,
                    style: AppStyles.normalStringStyle(15, AppColors.fullBlack),
                  ),
                  verticalSpacer(20),
                  controller.showLoading == true
                      ? loadingWidget()
                      : CustomButton(
                          buttonText: AppStrings.contineu,
                          width: screenWidth(context) * 0.5,
                          onPressed: () {
                            controller.makeDepositPayment(widget.booking);
                          },
                        ),
                  verticalSpacer(10),
                  controller.showLoading == true
                      ? const SizedBox.shrink()
                      : CustomButton(
                          buttonText: AppStrings.change,
                          width: screenWidth(context) * 0.5,
                          borderColor: AppColors.deepBlue,
                          color: AppColors.plainWhite,
                          textcolor: AppColors.deepBlue,
                          onPressed: () {
                            context.pop();
                          },
                        ),
                  verticalSpacer(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _keyText(String keyText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "$keyText:",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.floatingHintStringStyleColored(16, AppColors.deepBlue),
      ),
    );
  }

  Widget _valueText(String vaueText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        vaueText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.regularStringStyle(16, AppColors.reviewValueColor),
      ),
    );
  }
}
