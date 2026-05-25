// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/notifications_utils.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminBookingsController extends GetxController {
  AdminBookingsController();
  BookingModel? selectedBookingData;
  List<BookingModel>? bookingsList = [];
  String errMessage = '';
  bool showLoading = false;

  TextEditingController totalAmountController = TextEditingController();

  clearVals() {
    showLoading = false;
    errMessage = '';
    selectedBookingData = null;
    bookingsList = [];
    update();
  }

  selectCurrentBooking(BookingModel booking) {
    selectedBookingData = booking;
    // update();
  }

  fetchAllBooking() async {
    showLoading = true;
    update();
    bookingsList = await FirebaseService().adminFetchAllBookings();
    try {
      bookingsList?.sort((a, b) =>
          b.depositPayment!.paidAt!.compareTo(a.depositPayment!.paidAt!));
    } catch (e) {
      logger.e("Error sorting list");
    }
    logger.w("All Bookings: ${bookingsList?.length}");
    showLoading = false;
    update();
  }

  updateBookingTotalChargesAmount() async {
    if (totalAmountController.text.trim().isNotEmpty == true &&
        double.tryParse(totalAmountController.text.trim()) != null) {
      errMessage = '';
      showLoading = true;
      update();
      // Update amount here
      final totalServicecharge =
          double.tryParse(totalAmountController.text.trim());
      final updatedBookingDetails = selectedBookingData!
          .copyWith(totalCalculatedServiceCharge: totalServicecharge);
      logger.f('Updating Booking . . . ');
      final bookingResponse =
          await FirebaseService().updateBooking(updatedBookingDetails);
      if (bookingResponse == true) {
        selectedBookingData = updatedBookingDetails;
        logger.f('Updated successfully . . . ');
        sendBookingUpdateNotificationToClient(
          'Your total service charge is ${updatedBookingDetails.country == "USA" ? "\$" : "N"}${NumberFormat("#,###").format(totalServicecharge)}.',
          updatedBookingDetails.userId ?? '',
          updatedBookingDetails.customer?.email ?? '',
        );
        Fluttertoast.showToast(
          msg: "Update successfully",
          backgroundColor: AppColors.normalGreen,
        );
        fetchAllBooking();
      }
    } else {
      errMessage = "Enter a valid amount";
      Fluttertoast.showToast(msg: 'Enter a valid amout');
    }
    showLoading = false;
    update();
  }

  sendBookingUpdateNotificationToClient(
    String description,
    String receiverUserID,
    String receiverUserEmail,
  ) async {
    final notificationApiKey =
        await FirebaseService().fetchNotificationApiKey();

    if (notificationApiKey != null) {
      NotificationUtils().sendEmailNotification(
        emailAddress: receiverUserEmail,
        emailSubject: 'Updated booking alert',
        emailBody:
            '<h1>Updated Booking Alert</h1><p>\n$description\nPlease check your app for details.</p>',
      );

      NotificationUtils().sendPushNotification(
        notificationApiKey: notificationApiKey,
        title: "Updated booking alert",
        body: description,
        receiverExternalId: receiverUserID,
      );
    } else {
      logger.e("Error fetching notification key");
    }
  }
}
