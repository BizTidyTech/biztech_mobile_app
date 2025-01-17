import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/app/helpers/sharedprefs.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features_user/auth/auth_model/user_data_model.dart';
import 'package:tidytech/ui/features_user/home/data/services_data.dart';

class HomeController extends GetxController {
  HomeController();

  TextEditingController searchController = TextEditingController();
  CleaningCategory selectedCleaningCategory = CleaningCategory.all;
  UserData? userData;

  getUserData() async {
    userData = await getLocallySavedUserDetails();
    logger.f("User data: ${userData?.toJson()}");
    update();
  }

  changeSearchFilterCategory(CleaningCategory category) {
    selectedCleaningCategory = category;
    update();
  }
}
