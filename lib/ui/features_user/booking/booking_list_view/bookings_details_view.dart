// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/curved_container.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final controller = Get.put(BookingsListController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsListController>(
      init: BookingsListController(),
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
                AppStrings.bookingDetails,
                style: AppStyles.normalStringStyle(20, AppColors.fullBlack),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CustomCurvedContainer(
                    height: 390,
                    fillColor: AppColors.kPrimaryColor,
                    topPadding: 15,
                    leftPadding: 15,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 115,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              _keyText("Total Cost"),
                            ],
                          ),
                        ),
                        horizontalSpacer(8),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _valueText(
                                    "${widget.booking.service?.name ?? ''} Cleaning"),
                                _valueText(
                                    "\$${widget.booking.depositPayment?.amount}"),
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
                                _valueText(widget.booking
                                            .totalCalculatedServiceCharge ==
                                        null
                                    ? "Pending"
                                    : "\$${widget.booking.totalCalculatedServiceCharge}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    widget.booking.finalPayment == null
                        ? CupertinoIcons.hourglass
                        : CupertinoIcons.check_mark_circled,
                    color: widget.booking.finalPayment == null
                        ? AppColors.regularGray
                        : AppColors.normalGreen,
                    size: 80,
                  ),
                  const Spacer(),
                  Text(
                    widget.booking.finalPayment != null
                        ? "Final payment done!"
                        : widget.booking.totalCalculatedServiceCharge == null
                            ? "You will know the balance to pay when the total service charges are calculated"
                            : "You are to pay the balance of \$${(widget.booking.totalCalculatedServiceCharge! - double.parse(widget.booking.depositPayment!.amount!)).toStringAsFixed(1)}.",
                    textAlign: TextAlign.center,
                    style: widget.booking.finalPayment != null
                        ? AppStyles.regularStringStyle(17, AppColors.fullBlack)
                        : AppStyles.normalStringStyle(15, AppColors.fullBlack),
                  ),
                  const Spacer(),
                  controller.showLoading == true
                      ? loadingWidget()
                      : widget.booking.totalCalculatedServiceCharge == null ||
                              widget.booking.finalPayment != null
                          ? const SizedBox.shrink()
                          : CustomButton(
                              buttonText: AppStrings.payBalance,
                              width: screenWidth(context) * 0.5,
                              onPressed: () {
                                controller
                                    .makeBalanceFinalPayment(widget.booking);
                              },
                            ),
                  const Spacer(),
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
