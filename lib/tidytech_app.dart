// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/app/resources/app.router.dart';
import 'package:tidytech/app/services/navigation_service.dart';
import 'package:tidytech/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:tidytech/utils/app_constants/app_strings.dart';
import 'package:tidytech/utils/app_constants/app_theme_data.dart';

var logger = Logger(printer: PrettyPrinter());

class TidyTechApp extends StatelessWidget {
  TidyTechApp({super.key});

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
