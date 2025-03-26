import 'package:biztidy_mobile_app/app/resources/app.transitions.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_auth/admin_auth_view/admin_signin_view.dart';
import 'package:biztidy_mobile_app/ui/features_admin/admin_booking/admin_booking_list_view/admin_booking_list_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/create_account_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/onboarding_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/signin_user_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/auth/auth_view/verify_otp_screen.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_list_view/booking_list_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/booking/booking_view/booking_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_view/home_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/profile_views.dart';
import 'package:biztidy_mobile_app/ui/features_user/splash_screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/createAccountView',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      /// User App Pages
      GoRoute(
        path: '/onboardingScreen',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/createAccountView',
        builder: (context, state) => const CreateAccountView(),
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
        path: '/bookingsListScreen',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const BookingsListScreen(), key: state.pageKey),
      ),
      GoRoute(
        path: '/profileView',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const ProfileView(), key: state.pageKey),
      ),
    ],
  );
}

class AdminAppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/onboardingScreen',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AdminSignInView(),
      ),

      /// Admin App Pages
      GoRoute(
        path: '/adminBookingsListScreen',
        pageBuilder: (context, state) => CustomNormalTransition(
            child: const AdminBookingsListScreen(), key: state.pageKey),
      ),
    ],
  );
}
