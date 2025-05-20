import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/main_wrapper.dart';
import 'package:wangkie_app/models/video_model.dart';
import 'package:wangkie_app/repository/video_repository.dart';
import 'package:wangkie_app/screens/home/home_screen.dart';
import 'package:wangkie_app/screens/login/login_screen.dart';
import 'package:wangkie_app/screens/more/more_screen.dart';
import 'package:wangkie_app/screens/more/sub_screens/youtube_screen.dart';
import 'package:wangkie_app/screens/profile/profile_screen.dart';
import 'package:wangkie_app/screens/register/register_screen.dart';
import 'package:wangkie_app/screens/setting/setting_screen.dart';
import 'package:wangkie_app/screens/splash/splash_screen.dart';

class AppNavigation {
  AppNavigation._();
  static String initR = '/';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _rootNavigatorHome = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );
  static final _rootNavigatorSetting = GlobalKey<NavigatorState>(
    debugLabel: 'shellSetting',
  );
  static final _rootNavigatorMore = GlobalKey<NavigatorState>(
    debugLabel: 'shellMore',
  );
  // static final _rootNavigatorProfile = GlobalKey<NavigatorState>(
  //   debugLabel: 'shellProfile',
  // );
  static final GoRouter router = GoRouter(
    initialLocation: initR,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'Splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'Register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'Profile',
        pageBuilder:
            (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: ProfileScreen(key: state.pageKey),
            ),
      ),
      GoRoute(
        path: '/youtube',
        name: 'Youtube',
        pageBuilder:
            (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: YoutubeScreen(
                key: state.pageKey,
                video: state.extra as VideoModel,
              ),
            ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _rootNavigatorHome,
            routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (context, state) {
                  return HomeScreen(key: state.pageKey);
                },
                routes: [
                  // GoRoute(
                  //   path: 'subHome',
                  //   name: 'SubHome',
                  //   builder: (context, state) {
                  //     return SubHomeScreen(key: state.pageKey);
                  //   },
                  // )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorMore,
            routes: [
              GoRoute(
                path: '/more',
                name: 'More',
                builder: (context, state) {
                  return MoreScreen(
                    key: state.pageKey,
                    repository: VideoRepository(),
                  );
                },
                routes: [
                  // GoRoute(
                  //   path: 'subHome',
                  //   name: 'SubHome',
                  //   builder: (context, state) {
                  //     return SubHomeScreen(key: state.pageKey);
                  //   },
                  // )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorSetting,
            routes: [
              GoRoute(
                path: '/setting',
                name: 'Setting',
                builder: (context, state) {
                  return SettingScreen(key: state.pageKey);
                },
                routes: [
                  // GoRoute(
                  //   path: 'profile',
                  //   name: 'Profile',
                  //   pageBuilder:
                  //       (context, state) => NoTransitionPage(
                  //         key: state.pageKey,
                  //         child: ProfileScreen(key: state.pageKey),
                  //       ),
                  // ),
                ],
              ),
            ],
          ),

          // StatefulShellBranch(
          //   navigatorKey: _rootNavigatorRateUs,
          //   routes: [
          //     GoRoute(
          //       path: '/rateUs',
          //       name: 'RateUs',
          //       builder: (context, state) {
          //         return RateUsScreen(
          //           key: state.pageKey,
          //         );
          //       },
          //     )
          //   ],
          // ),
        ],
      ),
    ],
  );
}
