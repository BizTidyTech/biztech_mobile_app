// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/payment_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/paypal_response_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/push_notification_utils.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BookingsListController extends GetxController {
  BookingsListController();
  BookingModel? bookingData;
  List<BookingModel>? bookingsList = [];
  String errMessage = '';
  bool showLoading = false;

  clearVals() {
    showLoading = false;
    errMessage = '';
    bookingData = null;
    bookingsList = [];
    update();
  }

  fetchBookingsList() async {
    showLoading = true;
    update();
    bookingsList = await FirebaseService().fetchMyBookings();
    try {
      bookingsList?.sort((a, b) =>
          b.depositPayment!.paidAt!.compareTo(a.depositPayment!.paidAt!));
    } catch (e) {
      logger.e("Error sorting list");
    }
    logger.w("Bookings: ${bookingsList?.length}");
    showLoading = false;
    update();
  }

  makeBalanceFinalPayment(BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          "Making balance payment for ${bookingDetails.service?.name} with ID ${bookingDetails.bookingId}";
      double balanceAmount;
      try {
        balanceAmount = bookingDetails.totalCalculatedServiceCharge! -
            double.parse(bookingDetails.depositPayment!.amount!);
      } catch (e) {
        balanceAmount = bookingDetails.service!.baseCost! - 100;
      }
      await PaypalUtils().makePayment(
        amount: balanceAmount,
        bookingDetails: bookingDetails,
        description: description,
        isBalancePayment: true,
      );
    } catch (e) {
      logger.w("Error occured");
      Fluttertoast.showToast(msg: "Error occured. Kindly retry");
    }
    showLoading = false;
    update();
  }

  updateBookingFinalPayment(
      BookingModel bookingDetails, PaypalResponseModel paymentData) async {
    showLoading = true;
    update();
    final finalPaymentData = PaymentDetails(
      paidAt: DateTime.now(),
      paymentId: paymentData.paymentId,
      payerId: paymentData.payerId,
      status: paymentData.status,
      payerEmail: paymentData.data?.payer?.payerInfo?.email,
      amount: bookingDetails.depositPayment?.amount.toString(),
      payerName:
          "${paymentData.data?.payer?.payerInfo?.firstName} ${paymentData.data?.payer?.payerInfo?.lastName}",
    );
    final updatedBookingDetails =
        bookingDetails.copyWith(finalPayment: finalPaymentData);
    logger.w("Updated bookingDetails: ${updatedBookingDetails.toJson()}");

    logger.f('Updating Booking . . . ');
    final bookingResponse =
        await FirebaseService().updateBooking(updatedBookingDetails);
    if (bookingResponse == true) {
      NavigationService.navigatorKey.currentContext!.pop();
      logger.f('Booked successfully . . . ');
      sendUpdatedBookingNotificationToAdmin(
          bookingDetails.service?.name ?? 'cleaning service');
      Fluttertoast.showToast(
        msg: "Your appointment has been updated successfully",
        backgroundColor: AppColors.normalGreen,
      );
      fetchBookingsList();
    }
    showLoading = false;
    update();
  }

  sendUpdatedBookingNotificationToAdmin(String service) async {
    final notificationApiKey =
        await FirebaseService().fetchNotificationApiKey();

    final userData = await getLocallySavedUserDetails();

    if (notificationApiKey != null && userData != null) {
      PushNotificationUtils().sendNotificationToAdmin(
        notificationApiKey: notificationApiKey,
        title: "Updated booking alert",
        body:
            "There is an updated booking from ${userData.name ?? 'Client'} for $service",
        receiverExternalId: adminOnesignalExternalID,
      );
    } else {
      logger.e("Error sending notification");
    }
  }
}
