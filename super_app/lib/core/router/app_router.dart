import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/features/activity/screens/activity_screen.dart';
import 'package:super_app/features/auth/screens/phone_entry_screen.dart';
import 'package:super_app/features/auth/screens/otp_verification_screen.dart';
import 'package:super_app/features/food/screens/food_home_screen.dart';
import 'package:super_app/features/food/screens/food_order_tracking_screen.dart';
import 'package:super_app/features/food/screens/restaurant_detail_screen.dart';
import 'package:super_app/features/home/screens/home_screen.dart';
import 'package:super_app/features/home/screens/main_shell_screen.dart';
import 'package:super_app/features/notifications/screens/notifications_screen.dart';
import 'package:super_app/features/profile/screens/profile_screen.dart';
import 'package:super_app/features/ride/screens/active_ride_screen.dart';
import 'package:super_app/features/ride/screens/ride_booking_screen.dart';
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
      // Food routes
      GoRoute(
        path: '/food/restaurant/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return RestaurantDetailScreen(restaurantId: id);
        },
      ),
      GoRoute(
        path: '/food/order-tracking/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'FO-1002';
          return FoodOrderTrackingScreen(orderId: id);
        },
      ),
      // Ride routes
      GoRoute(
        path: '/rides/active/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'RD-5021';
          return ActiveRideScreen(rideId: id);
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
              child: FoodHomeScreen(),
            ),
          ),
          GoRoute(
            path: '/rides',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RideBookingScreen(),
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

// Temporary placeholder for Phase 6 Marketplace
class _BazaarPlaceholder extends StatelessWidget {
  const _BazaarPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Bazaar Module'));
}
