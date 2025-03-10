import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/core/constants.dart';
import 'package:shop_management_system/utils/helpers.dart';

// String Extensions
extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get slugify {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  }

  bool get isValidUrl {
    return RegExp(r'^(http|https):\/\/[^\s/$.?#].[^\s]*$').hasMatch(this);
  }

  Color get toColor {
    final hex = replaceAll('#', '');
    return Color(int.parse('0xFF$hex'));
  }
}

// Number Extensions
extension NumExtension on num {
  String get toCurrency {
    return CurrencyHelper.format(toDouble());
  }

  String get toFileSize {
    return FileHelper.getFileSize(toInt());
  }

  String get toPercentage {
    return '${toStringAsFixed(1)}%';
  }

  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
}

// List Extensions
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  List<T> sortedBy(Comparable Function(T element) getField) {
    final copy = [...this];
    copy.sort((a, b) => getField(a).compareTo(getField(b)));
    return copy;
  }

  List<T> sortedByDescending(Comparable Function(T element) getField) {
    final copy = [...this];
    copy.sort((a, b) => getField(b).compareTo(getField(a)));
    return copy;
  }

  Map<K, List<T>> groupBy<K>(K Function(T element) getKey) {
    final result = <K, List<T>>{};
    for (var element in this) {
      final key = getKey(element);
      (result[key] ??= []).add(element);
    }
    return result;
  }
}

// Map Extensions
extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }

  V? getNestedValue(String path) {
    final keys = path.split('.');
    dynamic current = this;
    
    for (var key in keys) {
      if (current is! Map) return null;
      current = current[key];
      if (current == null) return null;
    }
    
    return current as V?;
  }
}

// BuildContext Extensions
extension BuildContextExtension on BuildContext {
  // Theme extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // Media Query extensions
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  Brightness get platformBrightness => mediaQuery.platformBrightness;
  
  // Responsive breakpoints
  bool get isMobile => screenWidth < AppConstants.mobileBreakpoint;
  bool get isTablet => screenWidth >= AppConstants.mobileBreakpoint && 
                       screenWidth < AppConstants.tabletBreakpoint;
  bool get isDesktop => screenWidth >= AppConstants.tabletBreakpoint;
  
  // Shortcuts for showing dialogs/snackbars
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

// GetX Extensions
extension GetExtension on GetInterface {
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.dangerColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.successColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void showWarningSnackbar(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.warningColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstants.infoColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

// DateTime Extensions
extension DateTimeExtensions on DateTime {
  String get formatted => DateTimeHelper.formatDate(this);
  String get formattedWithTime => DateTimeHelper.formatDateTime(this);
  String get timeOnly => DateTimeHelper.formatTime(this);
  String get timeAgo => DateTimeHelper.timeAgo(this);

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));
  DateTime get endOfWeek => add(Duration(days: DateTime.daysPerWeek - weekday));
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  bool get isToday => isSameDate(DateTime.now());
  bool get isYesterday => isSameDate(DateTime.now().subtract(const Duration(days: 1)));
  bool get isTomorrow => isSameDate(DateTime.now().add(const Duration(days: 1)));
  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());
}
