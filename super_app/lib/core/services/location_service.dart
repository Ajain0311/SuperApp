import 'dart:math' as math;

class LocationCoordinates {
  final double latitude;
  final double longitude;
  final String formattedAddress;

  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });
}

class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  // Default Bengaluru center
  static const LocationCoordinates defaultLocation = LocationCoordinates(
    latitude: 12.9716,
    longitude: 77.5946,
    formattedAddress: 'Indiranagar 100ft Road, Bengaluru',
  );

  /// Calculate Haversine distance in kilometers between two GPS points
  double calculateDistanceKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(endLat - startLat);
    final dLon = _degreesToRadians(endLng - startLng);

    final lat1 = _degreesToRadians(startLat);
    final lat2 = _degreesToRadians(endLat);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    // Multiply by 1.25 for urban city road layout
    return double.parse((earthRadiusKm * c * 1.25).toStringAsFixed(1));
  }

  /// Estimate driving duration in minutes
  int estimateDurationMinutes(double distanceKm) {
    // 22 km/h average traffic speed
    return math.max(4, (distanceKm / 22.0 * 60).round());
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }
}
