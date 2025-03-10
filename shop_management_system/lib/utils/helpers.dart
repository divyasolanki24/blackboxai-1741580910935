import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('HH:mm').format(date);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class CurrencyHelper {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static double parse(String amount) {
    return double.parse(amount.replaceAll(_currencyFormat.symbols.CURRENCY_SYMBOL, '')
        .replaceAll(',', ''));
  }
}

class ValidationHelper {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

class ColorHelper {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
        return Colors.green;
      case 'pending':
      case 'in progress':
        return Colors.orange;
      case 'inactive':
      case 'failed':
      case 'error':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  static Color getRandomColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }
}

class FileHelper {
  static String getFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static IconData getFileIcon(String fileName) {
    final extension = getFileExtension(fileName);
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class StringHelper {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}

extension ContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 850;
  bool get isTablet => MediaQuery.of(this).size.width >= 850 && MediaQuery.of(this).size.width < 1100;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1100;
  
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  
  bool get isToday => isSameDay(DateTime.now());
  bool get isYesterday => isSameDay(DateTime.now().subtract(const Duration(days: 1)));
  bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));
}
