import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidytech/ui/features/home/data/services_data.dart';

class HomeController extends GetxController {
  HomeController();
  CleaningCategory selectedCleaningCategory = CleaningCategory.all;

  TextEditingController searchController = TextEditingController();

  chnageSearchFilterCategory(CleaningCategory category) {
    selectedCleaningCategory = category;
    update();
  }

  bookAppointment() {}
}
