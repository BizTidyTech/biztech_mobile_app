import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features/home/data/services_data.dart';

class HomeController extends GetxController {
  HomeController();
  CleaningCategory selectedCleaningCategory = CleaningCategory.all;
  UserData? userData;

  getUserData() async {
    userData = await getLocallySavedUserDetails();
    logger.f(userData?.toJson());
    update();
  }

  TextEditingController searchController = TextEditingController();

  chnageSearchFilterCategory(CleaningCategory category) {
    selectedCleaningCategory = category;
    update();
  }

  searchForServices(String searchText) {}

  bookAppointment() {}
}
