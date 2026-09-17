import 'package:flutter/foundation.dart';

/// Environment-driven configuration for SuperApp Flutter client.
/// 
/// Supports build-time and runtime switching via `--dart-define`:
/// 
/// Build Examples:
/// ```bash
/// # Development (default emulator localhost)
/// flutter run
/// 
/// # Development with physical device / custom IP
/// flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5000/api
/// 
/// # Staging build
/// flutter build apk --dart-define=ENV=staging
/// 
/// # Production build with explicit API URL
/// flutter build appbundle --dart-define=ENV=prod --dart-define=API_BASE_URL=https://api.superapp.com/api
/// ```
class AppEnvironment {
  AppEnvironment._();

  /// Target environment: 'dev', 'staging', 'prod'
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  /// Default API URLs per environment
  static const String _defaultDevBaseUrlAndroid = 'http://10.0.2.2:5000/api';
  static const String _defaultDevBaseUrlDefault = 'http://localhost:5000/api';
  static const String _defaultStagingBaseUrl = 'https://staging-api.superapp.com/api';
  static const String _defaultProdBaseUrl = 'https://api.superapp.com/api';

  /// Primary API Base URL resolved from dart-define or environment fallback
  static String get baseUrl {
    // 1. Check for explicit API_BASE_URL override
    const explicitUrl = String.fromEnvironment('API_BASE_URL');
    if (explicitUrl.isNotEmpty) {
      return explicitUrl;
    }

    // 2. Select default based on target environment
    switch (environment.toLowerCase()) {
      case 'prod':
      case 'production':
        return _defaultProdBaseUrl;
      case 'staging':
      case 'stage':
        return _defaultStagingBaseUrl;
      case 'dev':
      case 'development':
      default:
        // When running on Android emulator use 10.0.2.2, otherwise localhost
        if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
          return _defaultDevBaseUrlAndroid;
        }
        return _defaultDevBaseUrlDefault;
    }
  }

  /// Convenience environment checks
  static bool get isProduction =>
      environment.toLowerCase() == 'prod' || environment.toLowerCase() == 'production';

  static bool get isStaging =>
      environment.toLowerCase() == 'staging' || environment.toLowerCase() == 'stage';

  static bool get isDevelopment => !isProduction && !isStaging;

  /// Whether verbose network and state logs should be emitted
  static bool get enableLogging {
    const loggingOverride = bool.hasEnvironment('ENABLE_LOGS')
        ? bool.fromEnvironment('ENABLE_LOGS')
        : null;
    return loggingOverride ?? isDevelopment;
  }

  /// Real-time SignalR Hub URLs computed from resolved baseUrl
  static String get hubBaseUrl {
    final uri = Uri.parse(baseUrl);
    // Remove /api suffix if present to reach root host
    final rootPath = uri.path.endsWith('/api')
        ? uri.path.substring(0, uri.path.length - 4)
        : uri.path;
    return uri.replace(path: rootPath).toString().replaceAll(RegExp(r'/$'), '');
  }

  static String get rideHubUrl => '$hubBaseUrl/hubs/ride';
  static String get orderHubUrl => '$hubBaseUrl/hubs/order';
  static String get chatHubUrl => '$hubBaseUrl/hubs/chat';
}
