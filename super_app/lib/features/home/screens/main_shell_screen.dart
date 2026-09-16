import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/core/theme/app_colors.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    try {
      final location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/food')) return 1;
      if (location.startsWith('/rides')) return 2;
      if (location.startsWith('/bazaar')) return 3;
      return 0;
    } catch (_) {
      return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/food');
        break;
      case 2:
        context.go('/rides');
        break;
      case 3:
        context.go('/bazaar');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.divider,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: selectedIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.restaurant_rounded,
              label: 'Food',
              isSelected: selectedIndex == 1,
              badgeColor: AppColors.foodModule,
            ),
            _buildNavItem(
              icon: Icons.directions_bike_rounded,
              label: 'Rides',
              isSelected: selectedIndex == 2,
              badgeColor: AppColors.rideModule,
            ),
            _buildNavItem(
              icon: Icons.store_rounded,
              label: 'Bazaar',
              isSelected: selectedIndex == 3,
              badgeColor: AppColors.marketplaceModule,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    Color? badgeColor,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: badgeColor ?? AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
