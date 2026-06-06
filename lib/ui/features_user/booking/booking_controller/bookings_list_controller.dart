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
  bool ratingLoading = false;

  // bookingId → raw AgentJob data (status, agentId, agentEarnings …)
  Map<String, Map<String, dynamic>> jobDataCache = {};

  // ── Derived helpers ───────────────────────────────────────────────────────

  /// Bookings whose agent job is completed but the client hasn't rated yet.
  List<BookingModel> get unratedCompletedBookings =>
      (bookingsList ?? []).where((b) {
        if (b.isRated) return false;
        final job = jobDataCache[b.bookingId];
        return job != null && job['status'] == 'completed';
      }).toList();

  bool isJobCompleted(String? bookingId) {
    if (bookingId == null) return false;
    return jobDataCache[bookingId]?['status'] == 'completed';
  }

  String? agentIdForBooking(String? bookingId) {
    if (bookingId == null) return null;
    return jobDataCache[bookingId]?['agentId'] as String?;
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  clearVals() {
    showLoading = false;
    ratingLoading = false;
    errMessage = '';
    bookingData = null;
    bookingsList = [];
    jobDataCache = {};
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
      logger.e('Error sorting list');
    }
    logger.w('Bookings: ${bookingsList?.length}');
    showLoading = false;
    update();
    // Load job statuses in background — list renders immediately,
    // rating badges appear once this completes.
    _loadJobStatuses();
  }

  Future<void> _loadJobStatuses() async {
    final bookings = List<BookingModel>.from(bookingsList ?? []);
    for (final b in bookings) {
      if (b.bookingId == null || b.isRated) continue;
      final job = await FirebaseService().fetchAgentJob(b.bookingId!);
      if (job != null) {
        jobDataCache[b.bookingId!] = job;
      }
    }
    update();
  }

  // ── Rating ────────────────────────────────────────────────────────────────

  /// Submits a star rating + optional review.
  /// Writes to Bookings, AgentJobs, and Agents (transaction) atomically.
  Future<bool> submitRating({
    required BookingModel booking,
    required double rating,
    required String review,
  }) async {
    final agentId = agentIdForBooking(booking.bookingId);
    if (agentId == null || agentId.isEmpty) {
      Fluttertoast.showToast(msg: 'Could not find agent for this booking.');
      return false;
    }

    final isUSD = (booking.country ?? '') == 'USA';
    final jobCost = isUSD
        ? (booking.service?.usdCost ?? 0.0)
        : (booking.service?.baseCost ?? 0.0);

    ratingLoading = true;
    update();

    final success = await FirebaseService().submitJobRating(
      bookingId: booking.bookingId!,
      agentId: agentId,
      rating: rating,
      review: review,
      jobCost: jobCost,
      isUSD: isUSD,
    );

    if (success) {
      // Patch the local list immediately so the UI reflects the new rating
      final idx = bookingsList
              ?.indexWhere((b) => b.bookingId == booking.bookingId) ??
          -1;
      if (idx >= 0) {
        bookingsList![idx] = bookingsList![idx].copyWith(
          clientRating: rating,
          clientReview: review.trim().isEmpty ? null : review.trim(),
          ratedAt: DateTime.now(),
        );
      }
      Fluttertoast.showToast(
        msg: 'Thank you for your feedback!',
        backgroundColor: AppColors.normalGreen,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Could not submit rating. Please try again.',
      );
    }

    ratingLoading = false;
    update();
    return success;
  }

  // ── Payment ───────────────────────────────────────────────────────────────

  makeBalanceFinalPayment(BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          'Making balance payment for ${bookingDetails.service?.name} '
          'with ID ${bookingDetails.bookingId}';
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
        final desc =
            'Balance payment for ${bookingDetails.service?.name} '
            'booking with ID ${bookingDetails.bookingId}';
        await PaystackUtils().makePayment(
          NavigationService.navigatorKey.currentContext!,
          amount: balanceAmountInNaira,
          bookingDetails: bookingDetails,
          description: desc,
          isBalancePayment: false,
        );
      }
    } catch (e) {
      logger.w('Error occured');
      Fluttertoast.showToast(msg: 'Error occured. Kindly retry');
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
      amount: bookingDetails.totalCalculatedServiceCharge?.toString() ??
          bookingDetails.depositPayment?.amount.toString(),
      payerName:
          '${paymentData.data?.payer?.payerInfo?.firstName} '
          '${paymentData.data?.payer?.payerInfo?.lastName}',
    );
    final updatedBookingDetails =
        bookingDetails.copyWith(finalPayment: finalPaymentData);
    logger.w('Updated bookingDetails: ${updatedBookingDetails.toJson()}');

    final bookingResponse =
        await FirebaseService().updateBooking(updatedBookingDetails);
    if (bookingResponse == true) {
      NavigationService.navigatorKey.currentContext!.pop();
      sendUpdatedBookingNotificationToAdmin(bookingDetails);
      Fluttertoast.showToast(
        msg: 'Your appointment has been updated successfully',
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
      <p>You have received an update regarding a booking from ${userData.name ?? 'Client'} for ${booking.service?.name ?? 'cleaning service'}. Please check the admin panel for action. Find the details below:</p>
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
          title: 'Updated booking alert',
          body:
              'There is an updated booking from ${userData.name ?? 'Client'} '
              'for ${booking.service?.name ?? 'cleaning service'}',
          receiverExternalId: adminOnesignalExternalID,
        );
      }
    } else {
      logger.e('Error fetching notification key');
    }
  }
}
