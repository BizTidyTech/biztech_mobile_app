import 'dart:convert';

import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/bookings_list_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/paypal_response_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaypalUtils {
  makePayment({
    required double amount,
    required bookingDetails,
    required String description,
    required bool isBalancePayment,
  }) async {
    await Navigator.of(
      NavigationService.navigatorKey.currentContext!,
    ).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          // sandboxMode: true,
          clientId:
              "ASxtXE6BW_7OTbZanc7EKlbBkwbEtTitfYaYDNGIpcU820Wn6CfHyaF8D7AelJrCUULkups7eCQ9dCnI",
          secretKey:
              "EGu6r9-mSjO8gFvUjUUibdc3GlPSzHZQzyAgskDmNf_4wmDlGk5AGNC9jnSEOP4-8Wneu-R4uKf07pOm",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
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
            PaypalResponseModel paypalResponse = PaypalResponseModel();
            try {
              paypalResponse = paypalResponseModelFromJson(
                json.encode(response),
              );
              logger.w("Status: ${paypalResponse.status}");
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
                  .updateBookingFinalPayment(bookingDetails, paypalResponse);
            } else {
              await Get.put(BookingsController())
                  .bookAppointment(bookingDetails, paypalResponse);
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
