import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/core/theme/app_colors.dart';

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  int _selectedVehicleIndex = 0;

  final List<Map<String, dynamic>> _vehicles = [
    {
      'type': 'BIKE',
      'name': 'Bike Taxi',
      'tag': 'FASTEST',
      'tagColor': AppColors.secondary,
      'subtitle': 'Beat traffic • Helmet provided • 3m away',
      'fare': 45.0,
      'icon': Icons.two_wheeler_rounded,
    },
    {
      'type': 'AUTO',
      'name': 'Auto Rickshaw',
      'tag': 'VALUE',
      'tagColor': AppColors.blue,
      'subtitle': 'Direct drop • Max 3 seats • 5m away',
      'fare': 65.0,
      'icon': Icons.electric_rickshaw_rounded,
    },
    {
      'type': 'CAB',
      'name': 'Economy Cab',
      'tag': 'COMFORT',
      'tagColor': AppColors.purple,
      'subtitle': 'AC Hatchback • Luggage space • 7m away',
      'fare': 125.0,
      'icon': Icons.directions_car_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedVehicle = _vehicles[_selectedVehicleIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Find Your Ride'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.gps_fixed_rounded, color: AppColors.secondary, size: 14),
                SizedBox(width: 4),
                Text(
                  'GPS Online',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup / Dropoff Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PICKUP LOCATION',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Connaught Place, Central Delhi',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 2,
                          height: 20,
                          color: AppColors.border,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Divider(
                            height: 1,
                            color: AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DESTINATION',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Terminal 3, IGI Airport (DEL)',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Route Metrics Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.route_rounded, color: AppColors.blue, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '16.4 km • ~34 mins • Moderate Traffic',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Mock Route Map Visualizer
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF161B2E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  // Road grid lines
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MockRoutePainter(),
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 36,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text('Pickup', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 48,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_pin, color: Colors.white, size: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text('Airport T3', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AVAILABLE VEHICLES',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            // Vehicle Options List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vehicles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final v = _vehicles[index];
                final isSelected = index == _selectedVehicleIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedVehicleIndex = index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surfaceLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (v['tagColor'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            v['icon'] as IconData,
                            color: v['tagColor'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    v['name'] as String,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: (v['tagColor'] as Color).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      v['tag'] as String,
                                      style: TextStyle(
                                        color: v['tagColor'] as Color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                v['subtitle'] as String,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${(v['fare'] as double).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Bottom Action Bar
            Row(
              children: [
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.payment_rounded, color: AppColors.textSecondary, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Cash / UPI ▼',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/rides/active/RD-5021');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Book ${selectedVehicle['name']} • ₹${(selectedVehicle['fare'] as double).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MockRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(46, 40)
      ..cubicTo(size.width * 0.3, 10, size.width * 0.5, size.height - 20, size.width - 55, size.height - 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
