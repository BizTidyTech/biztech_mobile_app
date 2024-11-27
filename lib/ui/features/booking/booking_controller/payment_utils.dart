import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/booking/booking_model/paypal_response_model.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

class PaypalUtils {
  Future<PaypalResponseModel?> makePayment(
    BuildContext context, {
    required double amount,
    required bookingId,
    required description,
  }) async {
    final PaypalResponseModel? paymentResponse =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId:
              "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
          secretKey:
              "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
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
                    "name": "$bookingId booking",
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
              logger.w("error parsing data: $e");
            }
            Fluttertoast.showToast(
              msg: "Payment successful",
              backgroundColor: AppColors.normalGreen,
            );

            // Return Payment details here
            return paypalResponse;
          },
          onError: (error) {
            logger.w("onError: $error");
            return null;
          },
          onCancel: (params) {
            logger.w('cancelled: $params');
            return null;
          },
        ),
      ),
    );
    logger.f("Payment response: ${paymentResponse?.toJson()}");
    if (paymentResponse == null) {
      return null;
    } else {
      return paymentResponse;
    }
  }
}
