// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/tidytech_app.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
import 'package:tidytech/ui/shared/spacer.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_styles.dart';

class UserCustomNavBar extends StatefulWidget {
  final int currentPageIndx;
  const UserCustomNavBar({super.key, required this.currentPageIndx});

  @override
  State<UserCustomNavBar> createState() => _UserCustomNavBarState();
}

class _UserCustomNavBarState extends State<UserCustomNavBar> {
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
      height: 90,
      padding: const EdgeInsets.only(top: 15, right: 0, left: 0, bottom: 15),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lighterGray)),
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
                  ? goPopUntil(context, "homePage")
                  : context.go("/userHomePage");
            },
            child: _buildNavBarItem(
              barIndex: 0,
              label: AppStrings.home,
              activeIcon: Icons.home_filled,
              inactiveIcon: Icons.home_outlined,
            ),
          ),

          /// Bookings Icon
          GestureDetector(
            onTap: () {
              logger.i('Explore selected');
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
                  ? context.push('/userExplorePage')
                  : context.replace('/userExplorePage');
            },
            child: _buildNavBarItem(
              barIndex: 1,
              label: AppStrings.bookings,
              activeIcon: Icons.calendar_month,
              inactiveIcon: Icons.calendar_today_outlined,
            ),
          ),

          /// Notification Icon
          GestureDetector(
            onTap: () {
              logger.i('Favourite selected');
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
                  ? context.push('/userFavouritesPage')
                  : context.replace('/userFavouritesPage');
            },
            child: _buildNavBarItem(
              barIndex: 2,
              label: AppStrings.notifications,
              activeIcon: Icons.notifications_rounded,
              inactiveIcon: Icons.notifications_none_sharp,
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
                  ? context.push('/userProfilePage')
                  : context.replace('/userProfilePage');
            },
            child: _buildNavBarItem(
              barIndex: 3,
              label: AppStrings.profile,
              activeIcon: Icons.person,
              inactiveIcon: Icons.person_outline_rounded,
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
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            widget.currentPageIndx == barIndex ? activeIcon : inactiveIcon,
            color: widget.currentPageIndx == barIndex
                ? AppColors.deepBlue
                : AppColors.fullBlack,
          ),
          verticalSpacer(5),
          Text(
            label,
            style: AppStyles.subStringStyle(
              13,
              widget.currentPageIndx == barIndex
                  ? AppColors.deepBlue
                  : AppColors.fullBlack,
            ),
          ),
          verticalSpacer(15),
        ],
      ),
    );
  }
}
