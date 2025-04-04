// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/booking_key_text_value.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: AppColors.kPrimaryColor,
                    ),
                    child: Column(
                      children: [
                        keyTextValue(context, AppStrings.service,
                            "${widget.booking.service?.name ?? ''} Cleaning"),
                        keyTextValue(context, "Deposit Cost",
                            "${widget.booking.country == 'USA' ? "\$" : "N"}${NumberFormat("#,###").format(double.parse(widget.booking.depositPayment?.amount ?? '0'))}"),
                        keyTextValue(
                          context,
                          "Location",
                          widget.booking.locationName ?? '',
                        ),
                        keyTextValue(
                          context,
                          "Address",
                          widget.booking.locationAddress ?? '',
                        ),
                        keyTextValue(
                          context,
                          "Country",
                          widget.booking.country ?? '',
                        ),
                        keyTextValue(
                          context,
                          "Phone No",
                          widget.booking.customer?.phoneNumber ?? '',
                        ),
                        keyTextValue(
                          context,
                          "Rooms",
                          "${widget.booking.rooms ?? ''}",
                        ),
                        keyTextValue(
                          context,
                          "Duration",
                          "${widget.booking.duration ?? ''} hours",
                        ),
                        keyTextValue(
                          context,
                          "Date",
                          DateFormat('MMM d, y').format(
                              widget.booking.dateTime ?? DateTime.now()),
                        ),
                        keyTextValue(
                          context,
                          "Time",
                          DateFormat('h:mm a').format(
                              widget.booking.dateTime ?? DateTime.now()),
                        ),
                        keyTextValue(
                          context,
                          "Total Cost",
                          widget.booking.totalCalculatedServiceCharge == null
                              ? "Pending"
                              : "${widget.booking.country == 'USA' ? "\$" : "N"}${NumberFormat("#,###").format(widget.booking.totalCalculatedServiceCharge)}",
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
                            ? "You will know the balance to pay when the total service charge is calculated"
                            : "You are to pay the balance of ${widget.booking.country == 'USA' ? "\$" : "N"}${NumberFormat("#,###").format(widget.booking.totalCalculatedServiceCharge! - double.parse(widget.booking.depositPayment!.amount!))}.",
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
}
