import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/home/data/services_data.dart';
import 'package:tidytech/ui/features/home/home_controller/home_controller.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
import 'package:tidytech/ui/features/nav_bar/views/custom_navbar.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';
import 'package:tidytech/utils/extension_and_methods/string_cap_extensions.dart';

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
    controller.getUserData();
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
        child: Scaffold(
          backgroundColor: AppColors.plainWhite,
          bottomNavigationBar: const CustomNavBar(currentPageIndx: 0),
          appBar: PreferredSize(
            preferredSize: Size(screenWidth(context), 90),
            child: GetBuilder<HomeController>(
                init: HomeController(),
                builder: (_) {
                  return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).viewPadding.top),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    color: AppColors.plainWhite,
                    width: screenWidth(context) - 20,
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome${controller.userData?.name == null ? "" : ", ${controller.userData?.name?.split(' ')[0].toSentenceCase}"}",
                          style: AppStyles.defaultKeyStringStyle(23, 'Alice'),
                        ),
                        verticalSpacer(4),
                        Text(
                          AppStrings.tidyTechCaption.toSentenceCase,
                          style: AppStyles.regularStringStyle(
                              14, AppColors.deepBlue),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                _serviceCategoryWidget(),
                verticalSpacer(40),
                _popularServicesWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoriesCard(CleaningCategory category, String image) {
    double circleRadius =
        screenWidth(context) < 500 ? (screenWidth(context) - 40) * 0.245 : 120;
    return Container(
      height: circleRadius,
      width: circleRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kPrimaryColor,
      ),
      child: Column(
        children: [
          Container(
            height: circleRadius * 0.55,
            width: circleRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.transparent,
              image: DecorationImage(
                  image: AssetImage(image), fit: BoxFit.contain),
            ),
          ),
          verticalSpacer(2),
          Text(
            "${category.name.toSentenceCase}\n${AppStrings.cleaning}",
            textAlign: TextAlign.center,
            style: AppStyles.regularStringStyle(
              circleRadius * 0.116,
              AppColors.fullBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCategoryWidget() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppStrings.serviceCategory,
                    style: AppStyles.regularStringStyle(
                      20,
                      AppColors.fullBlack,
                    ),
                  ),
                ],
              ),
              verticalSpacer(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Entry.all(
                    duration: const Duration(seconds: 4),
                    child: _categoriesCard(
                      CleaningCategory.commercial,
                      'assets/commercial.png',
                    ),
                  ),
                  Entry.opacity(
                    duration: const Duration(seconds: 4),
                    child: _categoriesCard(
                      CleaningCategory.residential,
                      'assets/residential.png',
                    ),
                  ),
                  Entry.scale(
                    duration: const Duration(seconds: 4),
                    child: _categoriesCard(
                      CleaningCategory.industrial,
                      'assets/industrial.png',
                    ),
                  ),
                  Entry.offset(
                    duration: const Duration(seconds: 4),
                    child: _categoriesCard(
                      CleaningCategory.specialty,
                      'assets/specialty.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _popularServicesWidget() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppStrings.mostPopularService,
                    style: AppStyles.regularStringStyle(
                      20,
                      AppColors.fullBlack,
                    ),
                  ),
                ],
              ),
              verticalSpacer(20),
              Entry.offset(
                duration: const Duration(seconds: 4),
                xOffset: 300,
                yOffset: 1500,
                child: GridView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: popularServices.length,
                  itemBuilder: (context, index) => GestureDetector(
                    child: _popularServiceCard(popularServices[index]),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _popularServiceCard(ServiceModel service) {
    return Card(
      borderOnForeground: false,
      color: AppColors.plainWhite,
      elevation: 1,
      child: InkWell(
        onTap: () {
          logger.i("Pressed ${service.name}");
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 5),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 127,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(service.imageUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  service.name ?? '',
                  style: AppStyles.normalStringStyle(
                    16,
                    AppColors.fullBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<QudsPopupMenuBase> getCategoriesMenuItems(HomeController controller) {
  return [
    QudsPopupMenuItem(
      title: Text(
        CleaningCategory.all.name.toSentenceCase,
        style: AppStyles.normalStringStyle(14, AppColors.fullBlack),
      ),
      trailing: CleaningCategory.all == controller.selectedCleaningCategory
          ? const Icon(Icons.check_rounded)
          : null,
      onPressed: () async {
        controller.chnageSearchFilterCategory(CleaningCategory.all);
      },
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(
        CleaningCategory.commercial.name.toSentenceCase,
        style: AppStyles.normalStringStyle(14, AppColors.fullBlack),
      ),
      trailing:
          CleaningCategory.commercial == controller.selectedCleaningCategory
              ? const Icon(Icons.check_rounded)
              : null,
      onPressed: () async {
        controller.chnageSearchFilterCategory(CleaningCategory.commercial);
      },
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(
        CleaningCategory.residential.name.toSentenceCase,
        style: AppStyles.normalStringStyle(14, AppColors.fullBlack),
      ),
      trailing:
          CleaningCategory.residential == controller.selectedCleaningCategory
              ? const Icon(Icons.check_rounded)
              : null,
      onPressed: () async {
        controller.chnageSearchFilterCategory(CleaningCategory.residential);
      },
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(
        CleaningCategory.industrial.name.toSentenceCase,
        style: AppStyles.normalStringStyle(14, AppColors.fullBlack),
      ),
      trailing:
          CleaningCategory.industrial == controller.selectedCleaningCategory
              ? const Icon(Icons.check_rounded)
              : null,
      onPressed: () async {
        controller.chnageSearchFilterCategory(CleaningCategory.industrial);
      },
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(
        CleaningCategory.specialty.name.toSentenceCase,
        style: AppStyles.normalStringStyle(14, AppColors.fullBlack),
      ),
      trailing:
          CleaningCategory.specialty == controller.selectedCleaningCategory
              ? const Icon(Icons.check_rounded)
              : null,
      onPressed: () async {
        controller.chnageSearchFilterCategory(CleaningCategory.specialty);
      },
    ),
  ];
}
