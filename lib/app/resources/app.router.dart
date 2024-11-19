import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tidytech/app/resources/app.transitions.dart';
import 'package:tidytech/app/services/navigation_service.dart';
import 'package:tidytech/ui/features/auth/auth_view/create_account_view.dart';
import 'package:tidytech/ui/features/auth/auth_view/onboarding_view.dart';
import 'package:tidytech/ui/features/auth/auth_view/signin_user_view.dart';
import 'package:tidytech/ui/features/auth/auth_view/verify_otp_screen.dart';
import 'package:tidytech/ui/features/home/home_controller/home_controller.dart';
import 'package:tidytech/ui/features/home/home_view/home_view.dart';
import 'package:tidytech/ui/features/nav_bar/data/page_index_class.dart';
import 'package:tidytech/ui/features/nav_bar/views/custom_navbar.dart';
import 'package:tidytech/ui/features/splash_screen/splash_screen.dart';
import 'package:tidytech/utils/app_constants/app_colors.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/onboardingScreen',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      /// App Pages
      GoRoute(
        path: '/onboardingScreen',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/createAccountView',
        builder: (context, state) => CreateAccountView(),
      ),
      GoRoute(
        path: '/signInUserView',
        builder: (context, state) => SignInUserView(),
      ),
      GoRoute(
        path: '/verifyOtpScreen',
        builder: (context, state) => const VerifyOtpScreen(),
      ),
      GoRoute(
        path: '/homepageView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const HomepageView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/bookingsPage',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const BookingsView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/notificationsView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const NotificationsView(), key: state.pageKey),
      ),
      GoRoute(
        path: '/profileView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ProfileView(), key: state.pageKey),
      ),
    ],
  );
}

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

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
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 1),
              body: const Center(child: Text("Bookings")),
            );
          },
        ),
      ),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

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
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 2),
              body: const Center(child: Text("Notifications")),
            );
          },
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 3),
              body: const Center(child: Text("Profile")),
            );
          },
        ),
      ),
    );
  }
}
