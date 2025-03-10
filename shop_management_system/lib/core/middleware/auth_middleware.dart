import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/routes/app_routes.dart';
import 'package:shop_management_system/services/storage_service.dart';
import 'package:shop_management_system/models/user.dart';

class AuthMiddleware extends GetMiddleware {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    if (!_storageService.isLoggedIn() && 
        route != AppRoutes.LOGIN) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }

    // If user is logged in and tries to access login page, redirect to dashboard
    if (_storageService.isLoggedIn() && 
        route == AppRoutes.LOGIN) {
      return const RouteSettings(name: AppRoutes.DASHBOARD);
    }

    // Check role-based access
    if (_storageService.isLoggedIn() && 
        route != AppRoutes.LOGIN) {
      final User? user = _storageService.getUser();
      if (user != null && !hasAccess(user, route!)) {
        // Redirect to dashboard if user doesn't have access
        return const RouteSettings(name: AppRoutes.DASHBOARD);
      }
    }

    return null;
  }

  bool hasAccess(User user, String route) {
    // Define route permissions mapping
    final routePermissions = {
      AppRoutes.USERS: ['manage_users', 'view_users'],
      AppRoutes.ROLES: ['manage_roles', 'view_roles'],
      AppRoutes.PERMISSIONS: ['manage_permissions', 'view_permissions'],
      AppRoutes.MODULES: ['manage_modules', 'view_modules'],
      AppRoutes.SHOPS: ['manage_shops', 'view_shops'],
      AppRoutes.PRODUCTS: ['manage_products', 'view_products'],
      AppRoutes.INVENTORY: ['manage_inventory', 'view_inventory'],
    };

    // Check if route requires permissions
    final requiredPermissions = routePermissions[route];
    if (requiredPermissions == null) {
      return true; // No permissions required for this route
    }

    // Check if user has any of the required permissions
    return requiredPermissions.any((permission) => 
      user.permissions.contains(permission));
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {
    // Clean up resources if needed
  }
}

// Extension to add auth middleware to GetPage
extension AuthPageExtension on GetPage {
  GetPage protect() {
    return copyWith(middlewares: [AuthMiddleware(), ...?middlewares]);
  }
}
