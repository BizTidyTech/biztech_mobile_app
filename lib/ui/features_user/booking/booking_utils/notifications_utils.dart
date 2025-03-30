import 'dart:convert';

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initOneSignalPlatformState() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.warn);
  OneSignal.initialize(oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);
}

class NotificationUtils {
  // Notification URL endpoint
  final String url = 'https://api.onesignal.com/notifications';

  Future<void> sendPushNotification({
    required String notificationApiKey,
    required String receiverExternalId,
    required String title,
    required String body,
  }) async {
    // This function sends Push Notification using OneSignal
    final Map<String, dynamic> requestBody = {
      "app_id": oneSignalAppId,
      "target_channel": "push",
      "headings": {"en": title},
      "contents": {"en": body},
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

  Future<void> sendEmailNotification({
    required String notificationApiKey,
    required String emailAddress,
    required String emailSubject,
    required String emailBody,
    String? emailFrom,
    String? emailFromName,
  }) async {
    const String url = 'https://api.onesignal.com/notifications';

    final Map<String, dynamic> requestBody = {
      "app_id": oneSignalAppId,
      "include_email_tokens": [emailAddress],
      "email_subject": {"en": emailSubject},
      "email_body": {"en": emailBody},
    };

    if (emailFrom != null) requestBody["email_from_address"] = emailFrom;
    if (emailFromName != null) requestBody["email_from_name"] = emailFromName;

    // Remaining code as usual...
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
        logger.f("Email notification sent successfully: ${response.body}");
      } else {
        logger.w(
            "Failed to send email notification: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      logger.e("Error sending email notification: $e");
    }
  }
}
