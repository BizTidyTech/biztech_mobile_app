// ignore_for_file: depend_on_referenced_packages

import 'package:biztidy_mobile_app/app/resources/app.router.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_utils/push_notification_utils.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var logger = Logger(printer: PrettyPrinter());

class TidyTechApp extends StatefulWidget {
  const TidyTechApp({super.key});

  @override
  State<TidyTechApp> createState() => _TidyTechAppState();
}

class _TidyTechAppState extends State<TidyTechApp> {
  @override
  void initState() {
    super.initState();
    initOneSignalPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    /// ChangeNotifierProvider here
    return ChangeNotifierProvider(
      create: (_) => CurrentPage(),
      child: MaterialApp.router(
        /// MaterialApp params
        title: AppStrings.tidyTechTitle,
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appThemeData,

        /// GoRouter specific params
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

  // BuildContext? get ctx => _router.routerDelegate.navigatorKey.currentContext;
  final _router = AppRouter.router;
}

class AdminTidyTechApp extends StatefulWidget {
  const AdminTidyTechApp({super.key});

  @override
  State<AdminTidyTechApp> createState() => _AdminTidyTechAppState();
}

class _AdminTidyTechAppState extends State<AdminTidyTechApp> {
  @override
  void initState() {
    super.initState();
    initOneSignalPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    /// ChangeNotifierProvider here
    return ChangeNotifierProvider(
      create: (_) => CurrentPage(),
      child: MaterialApp.router(
        /// MaterialApp params
        title: AppStrings.tidyTechTitle,
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appThemeData,

        /// GoRouter specific params
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      ),
    );
  }

  // BuildContext? get ctx => _router.routerDelegate.navigatorKey.currentContext;
  final _router = AdminAppRouter.router;
}
