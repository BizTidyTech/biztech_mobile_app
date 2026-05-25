// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/payment_response_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/notifications_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/bookings_review_screen.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/payment_utils/paypal_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/payment_utils/paystack_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:provider/provider.dart';

class BookingsController extends GetxController {
  BookingsController();
  ServiceModel? selectedService;
  DateTime? appointmentDateSelected;
  BookingModel? bookingData;
  String errMessage = '';
  String userCountry = 'Nigeria';
  bool showLoading = false;
  LocationResult? userLocationData;
  // Full upfront payment — amount is determined by the selected service's baseCost
  double get fullPaymentAmountInNaira =>
      selectedService?.baseCost ?? 0.0;
  // For USD users, use the dedicated USD price on the service
  double get fullPaymentAmountInUSD =>
      selectedService?.usdCost ?? 0.0;

  TextEditingController roomsCountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  clearVals() {
    roomsCountController.clear();
    descriptionController.clear();
    phoneController.clear();
    bookingData = null;
    showLoading = false;
    errMessage = '';
    appointmentDateSelected = null;
    selectedService = null;
    update();
  }

  saveSelectedLocation(LocationResult location) {
    userLocationData = location;
    errMessage = '';
    update();
  }

  changeSelectedService(ServiceModel? service) {
    logger.i("Selected ${service?.name}");
    selectedService = service;
    update();
  }

  changeSelectedAppointmentDate(DateTime? dateTimeSelected) {
    appointmentDateSelected = dateTimeSelected;
    update();
  }

  Future<void> attemptToCreateAppointment(
    BuildContext context,
    double durationValue,
    double roomSqft,
  ) async {
    logger.i('attemptToCreateAppointment . . .');

    if (userLocationData == null) {
      errMessage = 'Choose your location address or landmark';
      update();
    } else if (phoneController.text.trim().isEmpty == true) {
      errMessage = 'Enter the phone number to contact';
      update();
    } else if (roomsCountController.text.trim().isEmpty == true) {
      errMessage = 'Enter your rooms count';
      update();
    } else {
      errMessage = '';
      update();
      await reviewBookingData(context, durationValue, roomSqft);
    }
  }

  reviewBookingData(
    BuildContext context,
    double durationValue,
    double roomSqft,
  ) async {
    final userData = await getLocallySavedUserDetails();
    userCountry = userData?.country ?? 'Nigeria';
    final newBookingData = BookingModel(
      bookingId: generateRandomString(),
      userId: userData?.userId,
      dateTime: appointmentDateSelected,
      locationName: userLocationData?.administrativeAreaLevel2?.longName,
      locationAddress: userLocationData?.formattedAddress,
      country: userCountry,
      additionalInfo: descriptionController.text.trim(),
      rooms: int.tryParse(roomsCountController.text.trim()) ?? 1,
      duration: durationValue.toInt(),
      roomSqFt: roomSqft,
      service: selectedService,
      customer: Customer(
        userId: userData?.userId,
        name: userData?.name,
        email: userData?.email,
        phoneNumber: phoneController.text.trim(),
      ),
    );
    bookingData = newBookingData;
    logger.w('Booking Data . . . ${bookingData?.toJson()}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingReviewScreen(booking: newBookingData);
        },
      ),
    );
  }

  makeFullPayment(BookingModel bookingDetails) async {
    logger.w("userCountry: $userCountry");
    if (userCountry == 'USA') {
      logger.w("Pay with PayPal");
      payWithPayPal(bookingDetails);
    } else {
      logger.f("Pay with PayStack");
      payWithPaystack(bookingDetails);
    }
  }

  payWithPayPal(BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          "Full payment for ${bookingDetails.service?.name} booking with ID ${bookingDetails.bookingId}";
      await PaypalUtils().makePayment(
        NavigationService.navigatorKey.currentContext!,
        amount: fullPaymentAmountInUSD,
        bookingDetails: bookingDetails,
        description: description,
        isBalancePayment: false,
      );
    } catch (e) {
      logger.w("Error occured");
    }
    showLoading = false;
    update();
  }

  payWithPaystack(BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          "Full payment for ${bookingDetails.service?.name} booking with ID ${bookingDetails.bookingId}";
      await PaystackUtils().makePayment(
        NavigationService.navigatorKey.currentContext!,
        amount: fullPaymentAmountInNaira,
        bookingDetails: bookingDetails,
        description: description,
        isBalancePayment: false,
      );
    } catch (e) {
      logger.w("Error occured");
    }
    showLoading = false;
    update();
  }

  bookAppointment(
    BookingModel bookingDetails,
    PaymentResponseModel paymentData,
  ) async {
    showLoading = true;
    update();
    final fullPaymentDetails = PaymentDetails(
      paidAt: DateTime.now(),
      paymentId: paymentData.paymentId,
      payerId: paymentData.payerId,
      status: paymentData.status,
      payerEmail: paymentData.data?.payer?.payerInfo?.email,
      amount: (userCountry == 'USA'
              ? fullPaymentAmountInUSD
              : fullPaymentAmountInNaira)
          .toString(),
      payerName:
          "${paymentData.data?.payer?.payerInfo?.firstName} ${paymentData.data?.payer?.payerInfo?.lastName}",
    );
    // Store full payment as both depositPayment and finalPayment — booking is fully paid upfront
    final updatedBookingDetails = bookingDetails.copyWith(
      depositPayment: fullPaymentDetails,
      finalPayment: fullPaymentDetails,
      totalCalculatedServiceCharge: userCountry == 'USA'
          ? fullPaymentAmountInUSD
          : fullPaymentAmountInNaira,
    );
    logger.w("Updated bookingDetails: ${updatedBookingDetails.toJson()}");

    logger.f('Booking appointment . . . ');
    final bookingResponse = await FirebaseService().bookAppointment(
      booking: updatedBookingDetails,
    );
    if (bookingResponse == true) {
      NavigationService.navigatorKey.currentContext!.pop();
      logger.f('Booked successfully . . . ');
      sendBookingNotificationToAdmin(bookingDetails);
      clearVals();
      // Go to bookings list screen
      Provider.of<CurrentPage>(NavigationService.navigatorKey.currentContext!,
              listen: false)
          .setCurrentPageIndex(0);
      NavigationService.navigatorKey.currentContext!.go('/homepageView');
      Fluttertoast.showToast(
        msg: "Your appointment has been booked successfully",
        backgroundColor: AppColors.normalGreen,
      );
    }
    showLoading = false;
    update();
  }

  sendBookingNotificationToAdmin(BookingModel booking) async {
    final notificationApiKey =
        await FirebaseService().fetchNotificationApiKey();

    final userData = await getLocallySavedUserDetails();

    if (userData != null) {
      final bookingDetails = NotificationUtils().createBookingDetails(booking);
      final String emailBody = '''
      '<h1>New Booking Alert</h1><p>There is a new booking from ${userData.name ?? 'Client'} for ${booking.service?.name ?? 'cleaning service'}. Please check the admin panel for action. Find the details below:</p>',
      <pre>$bookingDetails</pre>
    ''';

      NotificationUtils().sendEmailNotification(
        emailAddress: 'tidy1tech@gmail.com',
        emailSubject: 'New booking alert',
        emailBody: emailBody,
      );

      if (notificationApiKey != null) {
        NotificationUtils().sendPushNotification(
          notificationApiKey: notificationApiKey,
          title: "New booking alert",
          body:
              "There is a new booking from ${userData.name ?? 'Client'} for ${booking.service?.name ?? 'cleaning service'}",
          receiverExternalId: adminOnesignalExternalID,
        );
      }
    } else {
      logger.e("Error fetching notification key");
    }
  }
}
