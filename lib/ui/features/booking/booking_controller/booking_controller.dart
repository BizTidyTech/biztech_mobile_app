import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';

class BookingsController extends GetxController {
  BookingsController();
  ServiceModel? selectedService;
  UserData? userData;
  DateTime? appointmentDateSelected;

  TextEditingController searchController = TextEditingController();

  getUserData() async {
    userData = await getLocallySavedUserDetails();
    logger.f(userData?.toJson());
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

  bookAppointment() {}
}
