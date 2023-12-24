//pubdev packages
import 'package:go_router/go_router.dart';

//local packages
import 'package:wheatmap/feature/login_feature/view/splash_ui.dart';
import 'package:wheatmap/feature/login_feature/view/login_ui.dart';
import 'package:wheatmap/feature/bottom_bar.dart';

class AppRoutes {
  AppRoutes._();

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/LoginScreen',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeNavigator()),
    ],
  );
}
