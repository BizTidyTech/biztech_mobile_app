import 'package:biztidy_mobile_app/ui/features_user/home/data/services_data.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_controller/home_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_view/widgets/service_card.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryServicesView extends StatefulWidget {
  final CleaningCategory cleaningCategory;
  final List<ServiceModel> servicesList;
  const CategoryServicesView({
    super.key,
    required this.cleaningCategory,
    required this.servicesList,
  });

  @override
  State<CategoryServicesView> createState() => _CategoryServicesViewState();
}

class _CategoryServicesViewState extends State<CategoryServicesView> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.plainWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.plainWhite,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.plainWhite.withOpacity(0.4),
          title: Text(
            "${widget.cleaningCategory.name.toSentenceCase} Cleaning",
            style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.servicesList.length,
            itemBuilder: (context, index) {
              return serviceCard(widget.servicesList[index]);
            },
          ),
        ),
      ),
    );
  }
}
