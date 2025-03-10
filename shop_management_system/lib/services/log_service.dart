import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:shop_management_system/core/config.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  static LogService get instance => _instance;

  final bool _enableLogging = config.enableLogging;
  final LogLevel _logLevel = config.logLevel;

  // Debug level logging
  void d(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableLogging || _logLevel.index > LogLevel.debug.index) return;
    
    _log(
      'DEBUG',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[36m', // Cyan
    );
  }

  // Info level logging
  void i(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableLogging || _logLevel.index > LogLevel.info.index) return;
    
    _log(
      'INFO',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[32m', // Green
    );
  }

  // Warning level logging
  void w(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableLogging || _logLevel.index > LogLevel.warning.index) return;
    
    _log(
      'WARNING',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[33m', // Yellow
    );
  }

  // Error level logging
  void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_enableLogging || _logLevel.index > LogLevel.error.index) return;
    
    _log(
      'ERROR',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      color: '\x1B[31m', // Red
    );
  }

  // Network request logging
  void logRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    if (!_enableLogging || _logLevel.index > LogLevel.debug.index) return;

    final buffer = StringBuffer();
    buffer.writeln('➡️ REQUEST: $method $url');
    
    if (headers != null) {
      buffer.writeln('Headers:');
      headers.forEach((key, value) => buffer.writeln('  $key: $value'));
    }
    
    if (body != null) {
      buffer.writeln('Body:');
      buffer.writeln('  $body');
    }

    d(buffer.toString(), tag: 'Network');
  }

  // Network response logging
  void logResponse(String method, String url, int statusCode, dynamic body, Duration duration) {
    if (!_enableLogging || _logLevel.index > LogLevel.debug.index) return;

    final buffer = StringBuffer();
    buffer.writeln('⬅️ RESPONSE: $method $url');
    buffer.writeln('Status: $statusCode');
    buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    
    if (body != null) {
      buffer.writeln('Body:');
      buffer.writeln('  $body');
    }

    d(buffer.toString(), tag: 'Network');
  }

  // Performance logging
  void logPerformance(String operation, Duration duration, {String? tag}) {
    if (!_enableLogging || _logLevel.index > LogLevel.debug.index) return;

    i(
      'Operation "$operation" took ${duration.inMilliseconds}ms',
      tag: tag ?? 'Performance',
    );
  }

  // User action logging
  void logUserAction(String action, {Map<String, dynamic>? parameters}) {
    if (!_enableLogging || _logLevel.index > LogLevel.info.index) return;

    final buffer = StringBuffer('User Action: $action');
    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Parameters:');
      parameters.forEach((key, value) => buffer.writeln('  $key: $value'));
    }

    i(buffer.toString(), tag: 'UserAction');
  }

  // State change logging
  void logStateChange(String state, {String? from, String? to, String? details}) {
    if (!_enableLogging || _logLevel.index > LogLevel.debug.index) return;

    final buffer = StringBuffer('State Change: $state');
    if (from != null) buffer.write(' from: $from');
    if (to != null) buffer.write(' to: $to');
    if (details != null) {
      buffer.writeln();
      buffer.writeln('Details: $details');
    }

    d(buffer.toString(), tag: 'State');
  }

  // Internal logging helper
  void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    String color = '\x1B[37m', // Default to white
  }) {
    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    final prefix = '[$timeString][$level]${tag != null ? '[$tag]' : ''}';

    if (kDebugMode) {
      // Print colored output in debug mode
      print('$color$prefix $message\x1B[0m');
      
      if (error != null) {
        print('$color$prefix Error: $error\x1B[0m');
      }
      
      if (stackTrace != null) {
        print('$color$prefix StackTrace:\n$stackTrace\x1B[0m');
      }
    } else {
      // Use dart:developer log in release mode
      developer.log(
        message,
        time: now,
        name: tag ?? 'App',
        level: _getLevelNumber(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Convert log level string to number
  int _getLevelNumber(String level) {
    switch (level) {
      case 'DEBUG':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 0;
    }
  }
}

// Global instance
final logger = LogService.instance;
