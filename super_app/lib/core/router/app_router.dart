import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/features/activity/screens/activity_screen.dart';
import 'package:super_app/features/auth/screens/phone_entry_screen.dart';
import 'package:super_app/features/auth/screens/otp_verification_screen.dart';
import 'package:super_app/features/home/screens/home_screen.dart';
import 'package:super_app/features/home/screens/main_shell_screen.dart';
import 'package:super_app/features/notifications/screens/notifications_screen.dart';
import 'package:super_app/features/profile/screens/profile_screen.dart';
import 'package:super_app/features/splash/screens/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return OtpVerificationScreen(
            mobileNumber: extras['mobileNumber'] as String,
            isNewUser: extras['isNewUser'] as bool,
            isAdmin: extras['isAdmin'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/activity',
        builder: (context, state) {
          final tabStr = state.uri.queryParameters['tab'];
          final initialTab = int.tryParse(tabStr ?? '0') ?? 0;
          return ActivityScreen(initialTabIndex: initialTab);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/food',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _FoodPlaceholder(),
            ),
          ),
          GoRoute(
            path: '/rides',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _RidesPlaceholder(),
            ),
          ),
          GoRoute(
            path: '/bazaar',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _BazaarPlaceholder(),
            ),
          ),
        ],
      ),
    ],
  );
});

// Temporary placeholders for Phases 4, 5, 6
class _FoodPlaceholder extends StatelessWidget {
  const _FoodPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Food Module'));
}

class _RidesPlaceholder extends StatelessWidget {
  const _RidesPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Rides Module'));
}

class _BazaarPlaceholder extends StatelessWidget {
  const _BazaarPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Bazaar Module'));
}
