// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/app/resources/app.router.dart';
import 'package:tidytech/app/services/navigation_service.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_theme_data.dart';
import 'package:tidytech/utils/app_constants/constants.dart';

var logger = Logger(printer: PrettyPrinter());

class TidyTechApp extends StatefulWidget {
  const TidyTechApp({super.key});

  @override
  State<TidyTechApp> createState() => _TidyTechAppState();
}

class _TidyTechAppState extends State<TidyTechApp> {
  Future<void> initOneSignalPlatformState() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
  }

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
