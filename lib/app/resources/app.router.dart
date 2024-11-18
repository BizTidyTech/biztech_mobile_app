import 'package:go_router/go_router.dart';
import 'package:tidytech/app/services/navigation_service.dart';
import 'package:tidytech/ui/features/auth/auth_view/create_account_view.dart';
import 'package:tidytech/ui/features/auth/auth_view/onboarding_view.dart';
import 'package:tidytech/ui/features/auth/auth_view/signin_user_view.dart';
import 'package:tidytech/ui/features/splash_screen/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: '/createAccountView',
    // initialLocation: '/homepageView',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // /// App Pages
      GoRoute(
        path: '/onboardingScreen',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // GoRoute(
      //   path: '/homepageView',
      //   builder: (context, state) => const HomepageView(),
      // ),
      // GoRoute(
      //   path: '/recordPageView',
      //   builder: (context, state) => const RecordPageView(),
      // ),
      // GoRoute(
      //   path: '/profilePageView',
      //   builder: (context, state) => const ProfilePageView(),
      // ),
      // GoRoute(
      //   path: '/activityPageView',
      //   builder: (context, state) => const ActivityPageView(),
      // ),
      // //
      GoRoute(
        path: '/createAccountView',
        builder: (context, state) => CreateAccountView(),
      ),
      GoRoute(
        path: '/signInUserView',
        builder: (context, state) => SignInUserView(),
      ),
      // GoRoute(
      //   path: '/updateNewAccountView',
      //   builder: (context, state) => UpdateNewAccountView(),
      // ),
    ],
  );
}
