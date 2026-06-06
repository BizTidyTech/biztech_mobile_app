// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
    required String emailAddress,
    required String emailSubject,
    required String emailBody,
  }) async {
    const String emailEndpointUrl =
        'https://biztidy-email-service.onrender.com/send-email';

    final Map<String, dynamic> payload = {
      "recipients": [emailAddress],
      "subject": emailSubject,
      "body": emailBody,
      "cc": [],
      "attachment": []
    };

    try {
      final response = await http.post(
        Uri.parse(emailEndpointUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        logger.f('Notification Mail sent successfully!');
      } else {
        logger.w('Failed to send mail. Status: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Error sending email notification: $e");
    }
  }

  String createBookingDetails(BookingModel booking) {
    final buffer = StringBuffer();

    buffer.writeln('Booking Details:');
    buffer.writeln('--------------------------');
    buffer.writeln('Booking ID: ${booking.bookingId ?? 'N/A'}');
    buffer.writeln('User ID: ${booking.userId ?? 'N/A'}');
    buffer.writeln(
        'Date & Time: ${booking.dateTime != null ? DateFormat('EEEE, MMMM d, y, h:mma').format(booking.dateTime ?? DateTime.now()) : 'N/A'}');
    buffer.writeln(
        'Location: ${booking.locationName ?? 'N/A'}, ${booking.locationAddress ?? 'N/A'}, ${booking.country ?? 'N/A'}');
    buffer.writeln('Rooms: ${booking.rooms ?? 'N/A'}');
    buffer.writeln(
        'Duration: ${booking.duration != null ? '${booking.duration} hours' : 'N/A'}');
    buffer.writeln('Room SqFt: ${booking.roomSqFt ?? 'N/A'}');
    buffer.writeln('Additional Info: ${booking.additionalInfo ?? 'N/A'}');

    // Assuming ServiceModel has a 'name' property.
    if (booking.service != null) {
      buffer.writeln('Service: ${booking.service?.name ?? 'N/A'}');
    }

    if (booking.customer != null) {
      buffer.writeln('Customer:');
      buffer.writeln('  Name: ${booking.customer?.name ?? 'N/A'}');
      buffer.writeln('  Email: ${booking.customer?.email ?? 'N/A'}');
      buffer.writeln('  Phone: ${booking.customer?.phoneNumber ?? 'N/A'}');
    }

    if (booking.depositPayment != null) {
      buffer.writeln('Deposit Payment:');
      buffer.writeln(
          '  Payment ID: ${booking.depositPayment?.paymentId ?? 'N/A'}');
      buffer.writeln('  Amount: ${booking.depositPayment?.amount ?? 'N/A'}');
      buffer.writeln('  Status: ${booking.depositPayment?.status ?? 'N/A'}');
    }

    if (booking.finalPayment != null) {
      buffer.writeln('Final Payment:');
      buffer
          .writeln('  Payment ID: ${booking.finalPayment?.paymentId ?? 'N/A'}');
      buffer.writeln('  Amount: ${booking.finalPayment?.amount ?? 'N/A'}');
      buffer.writeln('  Status: ${booking.finalPayment?.status ?? 'N/A'}');
    }

    return buffer.toString();
  }
}
