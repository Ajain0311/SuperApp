import 'package:super_app/core/config/app_environment.dart';

class ApiConstants {
  ApiConstants._();

  /// Environment-driven API base URL
  static String get baseUrl => AppEnvironment.baseUrl;
  
  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String adminLogin = '/auth/admin-login';
  static const String profile = '/auth/profile';

  // Food
  static const String restaurants = '/restaurants';
  static const String foodOrders = '/food-orders';
  static const String validateCoupon = '/coupons/validate';

  // Ride
  static const String rideEstimate = '/rides/estimate';
  static const String rideBook = '/rides/book';
  static const String rides = '/rides';

  // Marketplace
  static const String marketplace = '/marketplace';
  static const String myListings = '/marketplace/my-listings';
  static const String favorites = '/marketplace/favorites';

  // Common
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
  static const String banners = '/banners';
  static const String reviews = '/reviews';
}
