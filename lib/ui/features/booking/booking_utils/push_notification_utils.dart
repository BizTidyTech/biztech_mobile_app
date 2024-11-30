import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/utils/app_constants/constants.dart';

class PushNotificationUtils {
  Future<void> sendNotificationToAdmin({
    required String notificationApiKey,
    required String service,
    required String receiverExternalId,
    required String senderName,
    bool? isNewBooking = true,
  }) async {
    // This function send Push Notification to the admin app
    // to inform them of the new bookings

    const String url = 'https://api.onesignal.com/notifications';

    final Map<String, dynamic> requestBody = {
      "app_id": oneSignalAppId,
      "target_channel": "push",
      "headings": {
        "en": isNewBooking == true
            ? "New booking alert"
            : "Updated booking alert",
      },
      "contents": {
        "en":
            "There is ${isNewBooking == true ? "a new" : "an updated"} booking from $senderName for $service"
      },
      "include_aliases": {
        "external_id": [receiverExternalId],
      },
    };
    logger.f("requestBody: ${requestBody.toString()}");

    final headers = {
      'Authorization': 'Basic $notificationApiKey',
      'accept': 'application/json',
      'content-type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        logger.f("Notification sent successfully: ${response.body}");
      } else {
        logger.w(
            "Failed to send notification: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      logger.e("Error sending notification: $e");
    }
  }
}
