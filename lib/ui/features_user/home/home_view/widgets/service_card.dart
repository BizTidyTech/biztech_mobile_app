import 'package:biztidy_mobile_app/app/helpers/sharedprefs.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Widget serviceCard(ServiceModel service, {bool? popPage}) {
  return Builder(builder: (context) {
    return FutureBuilder(
      future: getLocallySavedUserDetails(),
      builder: (context, snapshot) {
        final isUSA = snapshot.data?.country == 'USA';
        final priceDisplay = isUSA
            ? (service.usdCost != null
                ? '\$${NumberFormat("#,###").format(service.usdCost)}'
                : '')
            : (service.baseCost != null
                ? '₦${NumberFormat("#,###").format(service.baseCost)}'
                : '');
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 65,
            width: screenWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.plainWhite.withValues(alpha: 0.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth(context) - 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${service.name} Cleaning",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppStyles.regularStringStyle(
                                  15, AppColors.fullBlack),
                            ),
                            if (priceDisplay.isNotEmpty)
                              Text(
                                priceDisplay,
                                style: AppStyles.normalStringStyle(
                                    13, AppColors.deepBlue),
                              ),
                          ],
                        ),
                      ),
                      horizontalSpacer(10),
                      SizedBox(
                        height: 30,
                        child: CustomButton(
                          buttonText: AppStrings.book,
                          fontSize: 12,
                          width: 35,
                          onPressed: () {
                            Get.put(BookingsController())
                                .changeSelectedService(service);
                            Provider.of<CurrentPage>(context, listen: false)
                                .setCurrentPageIndex(1);
                            popPage == true
                                ? context.pop()
                                : context.push('/bookingsPage');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  });
}
