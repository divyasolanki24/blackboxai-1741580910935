import 'package:flutter/foundation.dart';
import 'package:shop_management_system/core/constants.dart';

enum Environment {
  development,
  staging,
  production,
}

class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  // Current environment
  static Environment environment = Environment.development;

  // API Configuration
  String get apiBaseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:3000/api';
      case Environment.staging:
        return 'https://staging-api.shopmanagement.com/api';
      case Environment.production:
        return 'https://api.shopmanagement.com/api';
    }
  }

  // Feature Flags
  bool get enableAnalytics => environment == Environment.production;
  bool get enableCrashReporting => environment == Environment.production;
  bool get enablePerformanceMonitoring => environment == Environment.production;
  bool get enableRemoteConfig => environment != Environment.development;

  // Cache Configuration
  Duration get cacheValidDuration {
    switch (environment) {
      case Environment.development:
        return const Duration(minutes: 5);
      case Environment.staging:
        return const Duration(hours: 1);
      case Environment.production:
        return const Duration(hours: 24);
    }
  }

  // API Timeouts
  Duration get connectionTimeout {
    switch (environment) {
      case Environment.development:
        return const Duration(seconds: 10);
      case Environment.staging:
        return const Duration(seconds: 20);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }

  Duration get receiveTimeout {
    switch (environment) {
      case Environment.development:
        return const Duration(seconds: 10);
      case Environment.staging:
        return const Duration(seconds: 20);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }

  // Logging Configuration
  bool get enableLogging => environment != Environment.production;
  LogLevel get logLevel {
    switch (environment) {
      case Environment.development:
        return LogLevel.debug;
      case Environment.staging:
        return LogLevel.info;
      case Environment.production:
        return LogLevel.error;
    }
  }

  // Security Configuration
  bool get enableSSLPinning => environment == Environment.production;
  bool get forceUpdate => environment == Environment.production;
  int get maxLoginAttempts => environment == Environment.production ? 5 : 100;

  // Performance Configuration
  int get maxConcurrentNetworkRequests {
    switch (environment) {
      case Environment.development:
        return 5;
      case Environment.staging:
        return 8;
      case Environment.production:
        return 10;
    }
  }

  // Cache Sizes
  int get maxImageCacheSize {
    switch (environment) {
      case Environment.development:
        return 100 * 1024 * 1024; // 100MB
      case Environment.staging:
        return 200 * 1024 * 1024; // 200MB
      case Environment.production:
        return 500 * 1024 * 1024; // 500MB
    }
  }

  // Pagination
  int get defaultPageSize => AppConstants.defaultPageSize;
  List<int> get availablePageSizes => AppConstants.availablePageSizes;

  // File Upload Limits
  int get maxFileUploadSize {
    switch (environment) {
      case Environment.development:
        return 10 * 1024 * 1024; // 10MB
      case Environment.staging:
        return 20 * 1024 * 1024; // 20MB
      case Environment.production:
        return 50 * 1024 * 1024; // 50MB
    }
  }

  // App Version
  String get appVersion => AppConstants.appVersion;
  int get minimumSupportedVersion {
    switch (environment) {
      case Environment.development:
        return 1;
      case Environment.staging:
        return 1;
      case Environment.production:
        return 1;
    }
  }

  // Debug Settings
  bool get showDebugBanner => environment != Environment.production;
  bool get enableDebugTools => environment != Environment.production;
  bool get mockServices => environment == Environment.development;

  // Error Reporting
  bool get reportErrors => environment != Environment.development;
  String get errorReportingDSN {
    switch (environment) {
      case Environment.development:
        return '';
      case Environment.staging:
        return 'https://staging-dsn.error-reporting.com';
      case Environment.production:
        return 'https://production-dsn.error-reporting.com';
    }
  }
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

// Extension to check if current platform is web
extension PlatformCheck on Config {
  bool get isWeb => kIsWeb;
  
  bool get isMobile => !kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || 
                                  defaultTargetPlatform == TargetPlatform.android);
  
  bool get isDesktop => !kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                                   defaultTargetPlatform == TargetPlatform.linux || 
                                   defaultTargetPlatform == TargetPlatform.macOS);
}

// Global instance
final config = Config();
