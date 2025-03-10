import 'package:get/get.dart';
import 'package:shop_management_system/core/middleware/auth_middleware.dart';
import 'package:shop_management_system/modules/auth/bindings/auth_binding.dart';
import 'package:shop_management_system/modules/auth/views/login_view.dart';
import 'package:shop_management_system/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:shop_management_system/modules/dashboard/views/dashboard_view.dart';
import 'package:shop_management_system/modules/inventory/bindings/inventory_binding.dart';
import 'package:shop_management_system/modules/inventory/views/inventory_view.dart';
import 'package:shop_management_system/modules/products/bindings/products_binding.dart';
import 'package:shop_management_system/modules/products/views/products_view.dart';
import 'package:shop_management_system/modules/shops/bindings/shops_binding.dart';
import 'package:shop_management_system/modules/shops/views/shops_view.dart';
import 'package:shop_management_system/modules/users/bindings/users_binding.dart';
import 'package:shop_management_system/modules/users/views/users_view.dart';
import 'package:shop_management_system/modules/roles/bindings/roles_binding.dart';
import 'package:shop_management_system/modules/roles/views/roles_view.dart';
import 'package:shop_management_system/modules/permissions/bindings/permissions_binding.dart';
import 'package:shop_management_system/modules/permissions/views/permissions_view.dart';
import 'package:shop_management_system/modules/modules/bindings/modules_binding.dart';
import 'package:shop_management_system/modules/modules/views/modules_view.dart';
import 'package:shop_management_system/routes/app_routes.dart';

class AppPages {
  static final routes = [
    // Auth Routes
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    // Main Routes (Protected)
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ).protect(),

    // Shop Management Routes
    GetPage(
      name: AppRoutes.SHOPS,
      page: () => const ShopsView(),
      binding: ShopsBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const ShopsView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const ShopsView(isEditing: true),
        ),
        GetPage(
          name: '/:id/inventory',
          page: () => const InventoryView(isShopSpecific: true),
          binding: InventoryBinding(),
        ),
        GetPage(
          name: '/:id/products',
          page: () => const ProductsView(isShopSpecific: true),
          binding: ProductsBinding(),
        ),
      ],
    ).protect(),

    // Product Management Routes
    GetPage(
      name: AppRoutes.PRODUCTS,
      page: () => const ProductsView(),
      binding: ProductsBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const ProductsView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const ProductsView(isEditing: true),
        ),
      ],
    ).protect(),

    // Inventory Management Routes
    GetPage(
      name: AppRoutes.INVENTORY,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
      children: [
        GetPage(
          name: '/adjust/:id',
          page: () => const InventoryView(isAdjusting: true),
        ),
      ],
    ).protect(),

    // User Management Routes
    GetPage(
      name: AppRoutes.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const UsersView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const UsersView(isEditing: true),
        ),
      ],
    ).protect(),

    // Role Management Routes
    GetPage(
      name: AppRoutes.ROLES,
      page: () => const RolesView(),
      binding: RolesBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const RolesView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const RolesView(isEditing: true),
        ),
      ],
    ).protect(),

    // Permission Management Routes
    GetPage(
      name: AppRoutes.PERMISSIONS,
      page: () => const PermissionsView(),
      binding: PermissionsBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const PermissionsView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const PermissionsView(isEditing: true),
        ),
      ],
    ).protect(),

    // Module Management Routes
    GetPage(
      name: AppRoutes.MODULES,
      page: () => const ModulesView(),
      binding: ModulesBinding(),
      children: [
        GetPage(
          name: '/create',
          page: () => const ModulesView(isCreating: true),
        ),
        GetPage(
          name: '/:id',
          page: () => const ModulesView(isEditing: true),
        ),
      ],
    ).protect(),

    // Profile Route
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const UsersView(isProfile: true),
      binding: UsersBinding(),
    ).protect(),
  ];
}
