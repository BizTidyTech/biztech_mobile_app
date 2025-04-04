// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_view/widgets/admin_input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/admin_booking_controller/admin_bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/shared/booking_key_text_value.dart';
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
import 'package:intl/intl.dart';

class AdminBookingDetailsScreen extends StatefulWidget {
  const AdminBookingDetailsScreen({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<AdminBookingDetailsScreen> createState() =>
      _AdminBookingDetailsScreenState();
}

class _AdminBookingDetailsScreenState extends State<AdminBookingDetailsScreen> {
  final controller = Get.put(AdminBookingsController());

  @override
  void initState() {
    super.initState();
    controller.selectCurrentBooking(widget.booking);
    controller.totalAmountController = TextEditingController(
      text: widget.booking.totalCalculatedServiceCharge?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminBookingsController>(
      init: AdminBookingsController(),
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
            body: SingleChildScrollView(
              child: Container(
                height: screenHeight(context),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: AppColors.kPrimaryColor,
                      ),
                      child: Column(
                        children: [
                          keyTextValue(context, AppStrings.service,
                              "${controller.selectedBookingData?.service?.name ?? ''} Cleaning"),
                          keyTextValue(context, "Deposit Cost",
                              "${controller.selectedBookingData?.country == 'USA' ? "\$" : "N"}${NumberFormat("#,###").format(double.parse(controller.selectedBookingData?.depositPayment?.amount ?? "0"))}"),
                          keyTextValue(
                            context,
                            "Location",
                            controller.selectedBookingData?.locationName ?? '',
                          ),
                          keyTextValue(
                            context,
                            "Address",
                            controller.selectedBookingData?.locationAddress ??
                                '',
                          ),
                          keyTextValue(
                            context,
                            "Country",
                            controller.selectedBookingData?.country ?? '',
                          ),
                          keyTextValue(
                            context,
                            "Phone No",
                            controller.selectedBookingData?.customer
                                    ?.phoneNumber ??
                                '',
                          ),
                          keyTextValue(
                            context,
                            "Rooms",
                            "${controller.selectedBookingData?.rooms ?? ''}",
                          ),
                          keyTextValue(
                            context,
                            "Duration",
                            "${controller.selectedBookingData?.duration ?? ''} hours",
                          ),
                          keyTextValue(
                            context,
                            "Date",
                            DateFormat('MMM d, y').format(
                                controller.selectedBookingData?.dateTime ??
                                    DateTime.now()),
                          ),
                          keyTextValue(
                            context,
                            "Time",
                            DateFormat('h:mm a').format(
                                controller.selectedBookingData?.dateTime ??
                                    DateTime.now()),
                          ),
                          keyTextValue(
                            context,
                            "Total Charges",
                            controller.selectedBookingData
                                        ?.totalCalculatedServiceCharge ==
                                    null
                                ? "Pending"
                                : "${controller.selectedBookingData?.country == 'USA' ? "\$" : "N"}${NumberFormat("#,###").format(controller.selectedBookingData?.totalCalculatedServiceCharge)}",
                          ),
                          keyTextValue(
                            context,
                            "Final Payment",
                            controller.selectedBookingData?.finalPayment == null
                                ? "Pending"
                                : "Paid",
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(20),
                    controller.selectedBookingData?.finalPayment == null
                        ? adminInputWidget(
                            titleText: AppStrings.updateTotalServiceCharge,
                            textEditingController:
                                controller.totalAmountController,
                            hintText: "Enter calculated total service charge",
                            keyboardType: TextInputType.number,
                          )
                        : const SizedBox.shrink(),
                    verticalSpacer(20),
                    controller.selectedBookingData?.finalPayment == null
                        ? controller.showLoading == true
                            ? loadingWidget()
                            : CustomButton(
                                buttonText: AppStrings.update,
                                width: screenWidth(context) * 0.5,
                                onPressed: () {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  controller.updateBookingTotalChargesAmount();
                                },
                              )
                        : const SizedBox.shrink(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
