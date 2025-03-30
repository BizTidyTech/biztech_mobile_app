// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/snackbar_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/payment_response_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaystackUtils {
  makePayment(
    BuildContext context, {
    required double amount,
    required BookingModel bookingDetails,
    required String description,
    required bool isBalancePayment,
  }) async {
    final amountInKobo = amount * 100;
    final paymentRef = 'ps_${DateTime.now().microsecondsSinceEpoch}';
    final userData = await getLocallySavedUserDetails();
    final paystackSecretKey = await FirebaseService().fetchPaystackApiKey();
    if (paystackSecretKey == null) {
      showCustomSnackBar(
        context,
        "Error processing payment. Check your internet and retry",
        bgColor: AppColors.coolRed,
      );
      return;
    }

    final request = PaystackTransactionRequest(
      reference: paymentRef,
      secretKey: paystackSecretKey,
      email: userData?.email ?? '',
      amount: amountInKobo,
      // amount: 10500,
      currency: PaystackCurrency.ngn,
      channel: [
        PaystackPaymentChannel.card,
        PaystackPaymentChannel.bankTransfer,
      ],
      metadata: {
        "description": description,
        "name": "${bookingDetails.bookingId} booking",
        "quantity": 1,
        "price": amount.toString(),
        "currency": "USD"
      },
    );

    final initializedTransaction =
        await PaymentService.initializeTransaction(request);

    if (!initializedTransaction.status) {
      logger.w(
          "initializedTransaction.message: ${initializedTransaction.message}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(initializedTransaction.message),
      ));

      return;
    }

    await PaymentService.showPaymentModal(
      context,
      transaction: initializedTransaction,
      callbackUrl: paystackLiveWebhookURL,
      onClosing: () {
        logger.w("Closed paystack modal");
      },
    );

    final response = await PaymentService.verifyTransaction(
      paystackSecretKey: paystackSecretKey,
      initializedTransaction.data?.reference ?? request.reference,
    );
    logger.f("Payment response from Paystack: \n${response.toMap()}");
    logger.w("Payment status: ${response.status}");

    if (response.status == true) {
      final paymentResponse = PaymentResponseModel(
        payerId: userData?.userId,
        paymentId: paymentRef,
        status: "Paid",
        data: Data(
          payer: Payer(
            payerInfo: PayerInfo(
              email: userData?.email,
              firstName: userData?.name,
              lastName: " ",
              payerId: userData?.userId,
            ),
          ),
        ),
      );
      Fluttertoast.showToast(
        msg: "Payment successful",
        backgroundColor: AppColors.normalGreen,
      );

      // Update and book appointment here
      if (isBalancePayment == true) {
        await Get.put(BookingsListController())
            .updateBookingFinalPayment(bookingDetails, paymentResponse);
      } else {
        await Get.put(BookingsController())
            .bookAppointment(bookingDetails, paymentResponse);
      }
    } else {
      showCustomSnackBar(context, response.message);
    }
  }
}
