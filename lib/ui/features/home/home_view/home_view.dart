import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/ui/features/home/home_controller/home_controller.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
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
  void initState() {
    super.initState();
    // Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
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
      ),
    );
  }
}
