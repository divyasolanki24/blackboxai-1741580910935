import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/core/middleware/auth_middleware.dart';
import 'package:shop_management_system/routes/app_routes.dart';
import 'package:shop_management_system/services/log_service.dart';
import 'package:shop_management_system/services/storage_service.dart';

class NavigationService extends GetxService {
  static NavigationService get to => Get.find();
  
  final StorageService _storageService = Get.find();
  final _navigationHistory = <String>[].obs;

  // Current route
  String get currentRoute => Get.currentRoute;

  // Navigation history
  List<String> get navigationHistory => _navigationHistory;

  // Initialize the service
  Future<NavigationService> init() async {
    // Add route observer
    Get.addPages(routes);
    return this;
  }

  // Custom routes with transitions
  final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
    // Add other routes here...
  ];

  // Navigation methods
  Future<T?>? to<T>(
    String route, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    try {
      _addToHistory(route);
      logger.i('Navigating to: $route', tag: 'Navigation');
      
      return Get.toNamed<T>(
        route,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
      );
    } catch (e, stackTrace) {
      logger.e(
        'Navigation error',
        tag: 'Navigation',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<T?>? off<T>(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    try {
      _addToHistory(route);
      logger.i('Navigating to (off): $route', tag: 'Navigation');
      
      return Get.offNamed<T>(
        route,
        arguments: arguments,
        parameters: parameters,
      );
    } catch (e, stackTrace) {
      logger.e(
        'Navigation error',
        tag: 'Navigation',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<T?>? offAll<T>(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    try {
      _clearHistory();
      _addToHistory(route);
      logger.i('Navigating to (offAll): $route', tag: 'Navigation');
      
      return Get.offAllNamed<T>(
        route,
        arguments: arguments,
        parameters: parameters,
      );
    } catch (e, stackTrace) {
      logger.e(
        'Navigation error',
        tag: 'Navigation',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  void back<T>({T? result}) {
    if (canGoBack) {
      _removeLastFromHistory();
      logger.i('Navigating back', tag: 'Navigation');
      Get.back<T>(result: result);
    }
  }

  // Check if can go back
  bool get canGoBack => _navigationHistory.length > 1;

  // Handle unauthorized access
  void handleUnauthorized() {
    _clearHistory();
    offAll(AppRoutes.LOGIN);
  }

  // Handle deep links
  Future<void> handleDeepLink(String link) async {
    try {
      final uri = Uri.parse(link);
      final path = uri.path;
      final parameters = uri.queryParameters;

      logger.i('Handling deep link: $link', tag: 'Navigation');

      // Check if user is logged in for protected routes
      if (_requiresAuth(path) && !_storageService.isLoggedIn()) {
        // Store the deep link to redirect after login
        await _storageService.setItem('pending_deep_link', link);
        offAll(AppRoutes.LOGIN);
        return;
      }

      // Navigate to the deep link
      to(path, parameters: parameters);
    } catch (e, stackTrace) {
      logger.e(
        'Deep link handling error',
        tag: 'Navigation',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Check pending deep links after login
  Future<void> checkPendingDeepLinks() async {
    try {
      final pendingLink = await _storageService.getItem<String>('pending_deep_link');
      if (pendingLink != null) {
        await _storageService.removeItem('pending_deep_link');
        handleDeepLink(pendingLink);
      }
    } catch (e, stackTrace) {
      logger.e(
        'Error checking pending deep links',
        tag: 'Navigation',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // History management
  void _addToHistory(String route) {
    _navigationHistory.add(route);
  }

  void _removeLastFromHistory() {
    if (_navigationHistory.isNotEmpty) {
      _navigationHistory.removeLast();
    }
  }

  void _clearHistory() {
    _navigationHistory.clear();
  }

  // Helper methods
  bool _requiresAuth(String route) {
    return route != AppRoutes.LOGIN;
  }

  // Custom transitions
  static Transition getTransitionByPlatform() {
    if (GetPlatform.isIOS) {
      return Transition.cupertino;
    }
    if (GetPlatform.isAndroid) {
      return Transition.rightToLeft;
    }
    return Transition.fadeIn;
  }
}

// Extension for easy access
extension NavigationServiceExtension on GetInterface {
  NavigationService get navigation => NavigationService.to;
}
