import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_app/core/theme/app_theme.dart';
import 'package:super_app/features/home/screens/main_shell_screen.dart';
import 'package:super_app/features/marketplace/screens/marketplace_home_screen.dart';
import 'package:super_app/features/ride/screens/ride_booking_screen.dart';

void main() {
  testWidgets('MainShellScreen renders all 4 module bottom navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(
          child: Scaffold(body: Center(child: Text('Shell Content'))),
        ),
      ),
    );

    // Verify 4 bottom navigation tabs are displayed
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Rides'), findsOneWidget);
    expect(find.text('Bazaar'), findsOneWidget);
  });

  testWidgets('MarketplaceHomeScreen renders header, categories, and Sell Item CTA', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MarketplaceHomeScreen(),
      ),
    );

    // Verify header branding
    expect(find.text('Community Marketplace'), findsOneWidget);
    expect(find.text('SUPER BAZAAR'), findsOneWidget);
    expect(find.text('Sell Item'), findsOneWidget);

    // Verify category pills
    expect(find.text('All'), findsAtLeastNWidgets(1));
    expect(find.text('Mobiles'), findsOneWidget);
    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
  });

  testWidgets('RideBookingScreen renders vehicle options and Book Ride CTA', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const RideBookingScreen(),
      ),
    );

    // Verify vehicle tier cards
    expect(find.text('Bike Taxi'), findsOneWidget);
    expect(find.text('Auto Rickshaw'), findsOneWidget);
    expect(find.text('Economy Cab'), findsOneWidget);

    // Verify booking CTA
    expect(find.textContaining('Book Bike Taxi'), findsOneWidget);
  });
}
