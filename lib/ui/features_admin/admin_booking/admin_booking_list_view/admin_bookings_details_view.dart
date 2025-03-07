// ignore_for_file: must_be_immutable

import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_view/widgets/admin_input_widget.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/admin_booking_controller/admin_bookings_list_controller.dart';
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
                    CustomCurvedContainer(
                      height: 420,
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
                                _keyText("Total Charges"),
                                _keyText("Final Payment"),
                              ],
                            ),
                          ),
                          horizontalSpacer(8),
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _valueText(
                                      "${controller.selectedBookingData?.service?.name ?? ''} Cleaning"),
                                  _valueText(
                                      "\$${controller.selectedBookingData?.depositPayment?.amount}"),
                                  _valueText(controller
                                          .selectedBookingData?.locationName ??
                                      ''),
                                  _valueText(controller.selectedBookingData
                                          ?.locationAddress ??
                                      ''),
                                  _valueText(controller.selectedBookingData
                                          ?.customer?.phoneNumber ??
                                      ''),
                                  _valueText(
                                      "${controller.selectedBookingData?.rooms ?? ''}"),
                                  _valueText(
                                      "${controller.selectedBookingData?.duration ?? ''} hours"),
                                  _valueText(DateFormat('MMM d, y').format(
                                      controller
                                              .selectedBookingData?.dateTime ??
                                          DateTime.now())),
                                  _valueText(DateFormat('h:mm a').format(
                                      controller
                                              .selectedBookingData?.dateTime ??
                                          DateTime.now())),
                                  _valueText(controller.selectedBookingData
                                              ?.totalCalculatedServiceCharge ==
                                          null
                                      ? "Pending"
                                      : "\$${controller.selectedBookingData?.totalCalculatedServiceCharge}"),
                                  _valueText(controller.selectedBookingData
                                              ?.finalPayment ==
                                          null
                                      ? "Pending"
                                      : "Done"),
                                ],
                              ),
                            ),
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
