// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/payment_response_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/notifications_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/payment_utils/paypal_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/payment_utils/paystack_utils.dart';
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

      final userCountry = (await getLocallySavedUserDetails())?.country;
      if (userCountry == 'USA') {
        await PaypalUtils().makePayment(
          NavigationService.navigatorKey.currentContext!,
          amount: balanceAmount,
          bookingDetails: bookingDetails,
          description: description,
          isBalancePayment: true,
        );
      } else {
        final balanceAmountInNaira = balanceAmount * 1500;
        final description =
            "Booking deposit for ${bookingDetails.service?.name} with ID ${bookingDetails.bookingId}";
        await PaystackUtils().makePayment(
          NavigationService.navigatorKey.currentContext!,
          amount: balanceAmountInNaira,
          bookingDetails: bookingDetails,
          description: description,
          isBalancePayment: false,
        );
      }
    } catch (e) {
      logger.w("Error occured");
      Fluttertoast.showToast(msg: "Error occured. Kindly retry");
    }
    showLoading = false;
    update();
  }

  updateBookingFinalPayment(
    BookingModel bookingDetails,
    PaymentResponseModel paymentData,
  ) async {
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
      sendUpdatedBookingNotificationToAdmin(bookingDetails);
      Fluttertoast.showToast(
        msg: "Your appointment has been updated successfully",
        backgroundColor: AppColors.normalGreen,
      );
      fetchBookingsList();
    }
    showLoading = false;
    update();
  }

  sendUpdatedBookingNotificationToAdmin(BookingModel booking) async {
    final notificationApiKey =
        await FirebaseService().fetchNotificationApiKey();

    final userData = await getLocallySavedUserDetails();

    if (userData != null) {
      final bookingDetails = NotificationUtils().createBookingDetails(booking);
      final String emailBody = '''
      <h1>Updated Booking Alert</h1>
      <p>You have received an update regarding a booking from ${userData.name ?? 'Client'} for ${booking.service?.name ?? 'cleaning service'}. Please check the admin panel for action. Find the details below:</p>',
      <pre>$bookingDetails</pre>
    ''';

      NotificationUtils().sendEmailNotification(
        emailAddress: 'tidy1tech@gmail.com',
        emailSubject: 'Updated booking alert',
        emailBody: emailBody,
      );

      if (notificationApiKey != null) {
        NotificationUtils().sendPushNotification(
          notificationApiKey: notificationApiKey,
          title: "Updated booking alert",
          body:
              "There is an updated booking from ${userData.name ?? 'Client'} for ${booking.service?.name ?? 'cleaning service'}",
          receiverExternalId: adminOnesignalExternalID,
        );
      }
    } else {
      logger.e("Error fetching notification key");
    }
  }
}
