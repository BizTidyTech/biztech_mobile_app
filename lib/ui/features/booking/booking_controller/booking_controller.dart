// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/app/services/firebase_service.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/booking/booking_controller/payment_utils.dart';
import 'package:tidytech/ui/features/booking/booking_model/booking_model.dart';
import 'package:tidytech/ui/features/booking/booking_utils/booking_success_dialog.dart';
import 'package:tidytech/ui/features/booking/booking_view/bookings_review_screen.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/extension_and_methods/string_cap_extensions.dart';

class BookingsController extends GetxController {
  BookingsController();
  ServiceModel? selectedService;
  DateTime? appointmentDateSelected;
  BookingModel? bookingData;
  String errMessage = '';
  bool showLoading = false;
  final depositBookingAmount = 100.0;

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

  makeDepositPayment(BuildContext context, BookingModel bookingDetails) async {
    showLoading = true;
    update();
    try {
      final description =
          "Booking deposit for ${bookingDetails.service?.name} with ID ${bookingDetails.bookingId}";
      final paymentData = await PaypalUtils().makePayment(
        context,
        amount: depositBookingAmount,
        bookingId: bookingDetails.bookingId,
        description: description,
      );
      logger.f("Returned paymentData: ${paymentData?.toJson()}");
      if (paymentData == null) {
        Fluttertoast.showToast(
          msg: "Error making payment. Kindly retry",
          backgroundColor: AppColors.coolRed,
        );
      } else {
        await bookAppointment(context, bookingDetails);
      }
    } catch (e) {
      logger.w("Error occured");
    }
    showLoading = true;
    update();
  }

  bookAppointment(BuildContext context, BookingModel bookingDetails) async {
    showLoading = true;
    update();
    logger.f('Booking appointment . . . ${bookingDetails.toJson()}');
    final bookingResponse = await FirebaseService().bookAppointment(
      booking: bookingDetails,
    );
    if (bookingResponse == true) {
      // Show booking uploaded successfully dialog
      await showBookingConfirmationDialog(context);
    }
    showLoading = false;
    update();
  }

  goToBookingsListScreen(BuildContext context) {
    logger.w("Going to bookings list screen . . . ");
    Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(2);
    context.push('/bookingsListScreen');
    clearVals();
  }
}
