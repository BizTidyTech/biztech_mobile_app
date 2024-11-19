import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tidytech/ui/features/home/home_controller/home_controller.dart';
import 'package:tidytech/ui/features/nav_bar/views/custom_navbar.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) {
          return Scaffold(
            backgroundColor: AppColors.plainWhite,
            bottomNavigationBar: const CustomNavBar(currentPageIndx: 0),
            body: const Center(child: Text("Home")),
          );
        },
      ),
    );
  }
}
