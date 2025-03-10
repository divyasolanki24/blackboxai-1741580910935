import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Shop Management System';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A comprehensive shop management system';
  
  // API Endpoints
  static const String baseUrl = 'http://localhost:3000/api';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String shopsEndpoint = '/shops';
  static const String productsEndpoint = '/products';
  static const String inventoryEndpoint = '/inventory';
  static const String rolesEndpoint = '/roles';
  static const String permissionsEndpoint = '/permissions';
  static const String modulesEndpoint = '/modules';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';

  // Pagination
  static const int defaultPageSize = 10;
  static const List<int> availablePageSizes = [10, 20, 50, 100];

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration apiCacheValidDuration = Duration(minutes: 5);

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // UI Constants
  static const double mobileBreakpoint = 850;
  static const double tabletBreakpoint = 1100;
  static const double maxContentWidth = 1200;
  static const double sideMenuWidth = 250;
  static const double appBarHeight = 60;
  static const double cardBorderRadius = 12;
  static const double defaultPadding = 16;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Colors
  static const MaterialColor primarySwatch = Colors.blue;
  static const Color secondaryColor = Color(0xFF6C757D);
  static const Color successColor = Color(0xFF28A745);
  static const Color dangerColor = Color(0xFFDC3545);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF17A2B8);
  
  // Status Colors
  static const Map<String, Color> statusColors = {
    'active': Color(0xFF28A745),
    'inactive': Color(0xFFDC3545),
    'pending': Color(0xFFFFC107),
    'processing': Color(0xFF17A2B8),
    'completed': Color(0xFF28A745),
    'cancelled': Color(0xFFDC3545),
    'draft': Color(0xFF6C757D),
  };

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFFC107),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred. Please check your connection.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String unauthorizedMessage = 'Unauthorized access. Please login again.';
  static const String notFoundMessage = 'Requested resource not found.';
  static const String validationErrorMessage = 'Please check the form for errors.';
  static const String genericErrorMessage = 'An error occurred. Please try again.';

  // Success Messages
  static const String saveSuccessMessage = 'Changes saved successfully.';
  static const String deleteSuccessMessage = 'Item deleted successfully.';
  static const String createSuccessMessage = 'Item created successfully.';
  static const String updateSuccessMessage = 'Item updated successfully.';

  // Confirmation Messages
  static const String deleteConfirmationMessage = 'Are you sure you want to delete this item?';
  static const String discardChangesMessage = 'Are you sure you want to discard changes?';
  static const String logoutConfirmationMessage = 'Are you sure you want to logout?';

  // Module Names
  static const String dashboardModule = 'Dashboard';
  static const String shopsModule = 'Shops';
  static const String productsModule = 'Products';
  static const String inventoryModule = 'Inventory';
  static const String usersModule = 'Users';
  static const String rolesModule = 'Roles';
  static const String permissionsModule = 'Permissions';
  static const String settingsModule = 'Settings';

  // Permission Actions
  static const String viewAction = 'view';
  static const String createAction = 'create';
  static const String editAction = 'edit';
  static const String deleteAction = 'delete';
  static const String exportAction = 'export';
  static const String importAction = 'import';
}
