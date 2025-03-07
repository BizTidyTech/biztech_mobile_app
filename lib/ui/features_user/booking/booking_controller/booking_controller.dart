// ignore_for_file: use_build_context_synchronously

import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/app/services/firebase_service.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/payment_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/booking_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_model/paypal_response_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/push_notification_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/bookings_review_screen.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BookingsController extends GetxController {
  BookingsController();
  ServiceModel? selectedService;
  DateTime? appointmentDateSelected;
  BookingModel? bookingData;
  String errMessage = '';
  bool showLoading = false;
  final depositBookingAmount = 20.0; // Initial depoit amount for all bookings

  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roomsCountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  clearVals() {
    locationController.clear();
    addressController.clear();
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
      BuildContext context, double durationValue, double roomSqft) async {
    logger.i('attemptToCreateAppointment . . .');

    if (locationController.text.trim().isEmpty == true) {
      errMessage = 'Enter your location/landmark name';
      update();
    } else if (addressController.text.trim().isEmpty == true) {
      errMessage = 'Enter your location address';
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
      BuildContext context, double durationValue, double roomSqft) async {
    final userData = await getLocallySavedUserDetails();
    final newBookingData = BookingModel(
      bookingId: generateRandomString(),
      userId: userData?.userId,
      dateTime: appointmentDateSelected,
      locationName: locationController.text.trim(),
      locationAddress: addressController.text.trim(),
      additionalInfo: descriptionController.text.trim(),
      rooms: int.tryParse(roomsCountController.text.trim()) ?? 1,
      duration: durationValue.toInt(),
      roomSqFt: roomSqft,
      service: selectedService,
      customer: Customer(
        userId: userData?.userId,
        name: userData?.name,
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

  makeDepositPayment(BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          "Booking deposit for ${bookingDetails.service?.name} with ID ${bookingDetails.bookingId}";
      await PaypalUtils().makePayment(
        amount: depositBookingAmount,
        bookingDetails: bookingDetails,
        description: description,
        isBalancePayment: false,
      );
    } catch (e) {
      logger.w("Error occured");
      Fluttertoast.showToast(msg: "Error occured. Kindly retry");
    }
    showLoading = false;
    update();
  }

  bookAppointment(
      BookingModel bookingDetails, PaypalResponseModel paymentData) async {
    showLoading = true;
    update();
    final initialDepositPayment = PaymentDetails(
      paidAt: DateTime.now(),
      paymentId: paymentData.paymentId,
      payerId: paymentData.payerId,
      status: paymentData.status,
      payerEmail: paymentData.data?.payer?.payerInfo?.email,
      amount: depositBookingAmount.toString(),
      payerName:
          "${paymentData.data?.payer?.payerInfo?.firstName} ${paymentData.data?.payer?.payerInfo?.lastName}",
    );
    final updatedBookingDetails =
        bookingDetails.copyWith(depositPayment: initialDepositPayment);
    logger.w("Updated bookingDetails: ${updatedBookingDetails.toJson()}");

    logger.f('Booking appointment . . . ');
    final bookingResponse = await FirebaseService().bookAppointment(
      booking: updatedBookingDetails,
    );
    if (bookingResponse == true) {
      NavigationService.navigatorKey.currentContext!.pop();
      logger.f('Booked successfully . . . ');
      sendBookingNotificationToAdmin(
          bookingDetails.service?.name ?? 'cleaning service');
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

  sendBookingNotificationToAdmin(String service) async {
    final notificationApiKey =
        await FirebaseService().fetchNotificationApiKey();

    final userData = await getLocallySavedUserDetails();

    if (notificationApiKey != null && userData != null) {
      PushNotificationUtils().sendNotificationToAdmin(
        notificationApiKey: notificationApiKey,
        title: "New booking alert",
        body:
            "There is a new booking from ${userData.name ?? 'Client'} for $service",
        receiverExternalId: adminOnesignalExternalID,
      );
    } else {
      logger.e("Error sending notification");
    }
  }
}
// ENIOLAsodiq5.
