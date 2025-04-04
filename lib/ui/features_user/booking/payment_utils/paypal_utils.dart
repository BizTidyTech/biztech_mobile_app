// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/app/services/snackbar_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/payment_response_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaypalUtils {
  makePayment(
    BuildContext context, {
    required double amount,
    required bookingDetails,
    required String description,
    required bool isBalancePayment,
  }) async {
    // Returns [paypalSecretKey, paypalClientId]
    final paypalCredentials =
        await FirebaseService().fetchPayPalSecretKeyAndClientID();
    if (paypalCredentials == null) {
      showCustomSnackBar(
        context,
        "Error processing payment. Check your internet and retry",
        bgColor: AppColors.coolRed,
      );
      return;
    }

    await Navigator.of(
      NavigationService.navigatorKey.currentContext!,
    ).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          // sandboxMode: true,
          secretKey: paypalCredentials[0],
          clientId: paypalCredentials[1],
          transactions: [
            {
              "amount": {
                "total": amount.toString(),
                "currency": "USD",
                "details": {
                  "subtotal": amount.toString(),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": description,
              "item_list": {
                "items": [
                  {
                    "name": "${bookingDetails.bookingId} booking",
                    "quantity": 1,
                    "price": amount.toString(),
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "Contact us for any questions on your booking.",
          onSuccess: (Map response) async {
            logger.f("onSuccess: $response");
            PaymentResponseModel paymentResponse = PaymentResponseModel();
            try {
              paymentResponse = paypalResponseModelFromJson(
                json.encode(response),
              );
              logger.w("Status: ${paymentResponse.status}");
            } catch (e) {
              logger.w("Error parsing data: $e");
            }
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
          },
          onError: (error) {
            logger.w("onError: $error");
            Fluttertoast.showToast(
              msg: "Payment unsuccessful. Kindly retry",
              backgroundColor: AppColors.coolRed,
            );
            return null;
          },
          onCancel: (params) {
            logger.w('cancelled: $params');
            Fluttertoast.showToast(msg: "Payment cancelled");
            return null;
          },
        ),
      ),
    );
  }
}
