import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/home/data/services_data.dart';
import 'package:tidytech/ui/features/home/home_controller/home_controller.dart';
import 'package:tidytech/ui/features/home/home_model/services_model.dart';
import 'package:tidytech/ui/shared/custom_button.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';
import 'package:tidytech/utils/extension_and_methods/screen_utils.dart';
import 'package:tidytech/utils/extension_and_methods/string_cap_extensions.dart';

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
              return _serviceCard(widget.servicesList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 222,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: 222,
            width: screenWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(service.imageUrl ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 80,
            width: screenWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.plainWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${service.name} Cleaning",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppStyles.normalStringStyle(17, AppColors.fullBlack),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "From: ",
                        style: AppStyles.normalStringStyle(
                          14,
                          AppColors.fullBlack,
                        ),
                        children: [
                          TextSpan(
                            text: "\$${service.baseCost}",
                            style: AppStyles.keyStringStyle(
                              17,
                              AppColors.fullBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: CustomButton(
                        buttonText: AppStrings.book,
                        fontSize: 12,
                        width: 35,
                        onPressed: () {
                          logger.i('Go to bookings screen');
                          // TODO: Go to bookings screen
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
