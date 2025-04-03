// ignore_for_file: depend_on_referenced_packages

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatefulWidget {
  final int currentPageIndx;
  const CustomNavBar({super.key, required this.currentPageIndx});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  void goPopUntil(BuildContext context, String routeName) {
    final router = GoRouter.of(context);
    while (router
            .routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        "/$routeName") {
      if (!context.canPop()) {
        return;
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lighterGray)),
        color: AppColors.plainWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Home Icon
          GestureDetector(
            onTap: () {
              logger.i('Home selected');
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(0);
              context.canPop()
                  ? goPopUntil(context, "homepageView")
                  : context.go("/homepageView");
            },
            child: _buildNavBarItem(
              barIndex: 0,
              label: AppStrings.home,
              activeIcon: Iconsax.home_25,
              inactiveIcon: Iconsax.home_24,
            ),
          ),

          /// Bookings Icon
          GestureDetector(
            onTap: () {
              logger.i('Bookings selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(1);
              logger.i('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/bookingsPage')
                  : context.replace('/bookingsPage');
            },
            child: _buildNavBarItem(
              barIndex: 1,
              label: AppStrings.bookings,
              activeIcon: Iconsax.calendar5,
              inactiveIcon: Iconsax.calendar_1,
            ),
          ),

          /// Appointments Icon
          GestureDetector(
            onTap: () {
              logger.i('Appointments selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(2);
              logger.i('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/bookingsListScreen')
                  : context.replace('/bookingsListScreen');
            },
            child: _buildNavBarItem(
              barIndex: 2,
              label: AppStrings.appointments,
              activeIcon: IconsaxPlusBold.archive_book,
              inactiveIcon: IconsaxPlusLinear.archive_book,
              // activeIcon: Iconsax.notification5,
              // inactiveIcon: Iconsax.notification4,
            ),
          ),

          /// Profile Icon
          GestureDetector(
            onTap: () {
              logger.i('Profile selected');
              final bool currentPageIndexCheck =
                  Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? true
                      : false;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(3);
              logger.i('currentPageIndexCheck: $currentPageIndexCheck');
              currentPageIndexCheck == true
                  ? context.push('/profileView')
                  : context.replace('/profileView');
            },
            child: _buildNavBarItem(
              barIndex: 3,
              label: AppStrings.profile,
              activeIcon: IconsaxPlusBold.profile,
              inactiveIcon: IconsaxPlusLinear.profile,
            ),
          ),
        ],
      ),
    );
  }

  _buildNavBarItem(
      {required int barIndex,
      required String label,
      required IconData activeIcon,
      required IconData inactiveIcon}) {
    return SizedBox(
      width: 70,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.currentPageIndx == barIndex ? activeIcon : inactiveIcon,
            color: widget.currentPageIndx == barIndex
                ? AppColors.deepBlue
                : AppColors.fullBlack.withValues(alpha: 0.8),
            size: 30,
          ),
          Text(
            label,
            style: AppStyles.subStringStyle(
              10,
              widget.currentPageIndx == barIndex
                  ? AppColors.deepBlue
                  : AppColors.fullBlack.withValues(alpha: 0.8),
            ).copyWith(
              fontWeight: widget.currentPageIndx == barIndex
                  ? FontWeight.w900
                  : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
