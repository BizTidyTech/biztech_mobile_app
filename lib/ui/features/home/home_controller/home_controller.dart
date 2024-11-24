import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features/home/data/services_data.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';

class HomeController extends GetxController {
  HomeController();

  TextEditingController searchController = TextEditingController();
  CleaningCategory selectedCleaningCategory = CleaningCategory.all;
  UserData? userData;

  getUserData() async {
    userData = await getLocallySavedUserDetails();
    logger.f(userData?.toJson());
    update();
  }

  changeSearchFilterCategory(CleaningCategory category) {
    selectedCleaningCategory = category;
    update();
  }

  chooseServiceToBook(ServiceModel service) {
  }

  searchForServices(String searchText) {}

  bookAppointment() {}
}
