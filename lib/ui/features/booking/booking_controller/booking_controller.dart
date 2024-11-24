// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/app/services/firebase_service.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/booking/booking_model/booking_model.dart';
import 'package:tidytech/ui/features/booking/booking_view/bookings_review_screen.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';
import 'package:tidytech/utils/extension_and_methods/string_cap_extensions.dart';

class BookingsController extends GetxController {
  BookingsController();
  ServiceModel? selectedService;
  DateTime? appointmentDateSelected;
  String errMessage = '';
  bool showLoading = false;

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

  Future<void> attemptToBookAppointment(
      BuildContext context, double durationValue, double roomSqft) async {
    logger.i('attemptToBookAppointment . . .');

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
      await reviewAppointment(context, durationValue, roomSqft);
    }
  }

  reviewAppointment(
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
    logger.w('Booking Data . . . ${newBookingData.toJson()}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookingReviewScreen(booking: newBookingData);
        },
      ),
    );
  }

  makePayment(){}

  bookAppointment(BookingModel bookingData) async {
    showLoading = true;
    update();
    logger.f('Booking appointment . . . ${bookingData.toJson()}');
    final bookingResponse = await FirebaseService().bookAppointment(
      booking: bookingData,
    );
    if (bookingResponse == true) {
      // Show dialog
            
    }
    showLoading = false;
    update();
  }
}
