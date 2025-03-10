import 'package:get/get.dart';
import 'package:shop_management_system/models/role_permission.dart';
import 'package:shop_management_system/models/user.dart';
import 'package:shop_management_system/services/storage_service.dart';
import 'package:shop_management_system/services/log_service.dart';

class PermissionService extends GetxService {
  static PermissionService get to => Get.find();
  
  final StorageService _storageService = Get.find();
  
  // Cache the current user's permissions
  final _permissions = <String>[].obs;
  final _role = Rx<Role?>(null);

  // Initialize the service
  Future<PermissionService> init() async {
    await _loadUserPermissions();
    return this;
  }

  // Load user permissions from storage
  Future<void> _loadUserPermissions() async {
    try {
      final user = _storageService.getUser();
      if (user != null) {
        _permissions.value = user.permissions;
        logger.i('Loaded ${_permissions.length} permissions', tag: 'Permissions');
      }
    } catch (e, stackTrace) {
      logger.e(
        'Error loading permissions',
        tag: 'Permissions',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Update permissions when user changes
  Future<void> updatePermissions(User user) async {
    _permissions.value = user.permissions;
    logger.i('Updated permissions for user ${user.id}', tag: 'Permissions');
  }

  // Clear permissions on logout
  void clearPermissions() {
    _permissions.clear();
    _role.value = null;
    logger.i('Cleared permissions', tag: 'Permissions');
  }

  // Check if user has a specific permission
  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  // Check if user has any of the given permissions
  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((permission) => _permissions.contains(permission));
  }

  // Check if user has all of the given permissions
  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((permission) => _permissions.contains(permission));
  }

  // Check module access
  bool canAccessModule(String module) {
    return hasAnyPermission([
      '${module}_view',
      '${module}_create',
      '${module}_edit',
      '${module}_delete',
    ]);
  }

  // Check specific actions
  bool canView(String module) {
    return hasPermission('${module}_view');
  }

  bool canCreate(String module) {
    return hasPermission('${module}_create');
  }

  bool canEdit(String module) {
    return hasPermission('${module}_edit');
  }

  bool canDelete(String module) {
    return hasPermission('${module}_delete');
  }

  // Predefined permission checks for common modules
  bool get canManageUsers => hasAnyPermission([
    'users_create',
    'users_edit',
    'users_delete',
  ]);

  bool get canManageRoles => hasAnyPermission([
    'roles_create',
    'roles_edit',
    'roles_delete',
  ]);

  bool get canManagePermissions => hasAnyPermission([
    'permissions_create',
    'permissions_edit',
    'permissions_delete',
  ]);

  bool get canManageShops => hasAnyPermission([
    'shops_create',
    'shops_edit',
    'shops_delete',
  ]);

  bool get canManageProducts => hasAnyPermission([
    'products_create',
    'products_edit',
    'products_delete',
  ]);

  bool get canManageInventory => hasAnyPermission([
    'inventory_create',
    'inventory_edit',
    'inventory_delete',
  ]);

  // Get all permissions for a module
  List<String> getModulePermissions(String module) {
    return _permissions.where((p) => p.startsWith(module)).toList();
  }

  // Check if user is admin
  bool get isAdmin => hasPermission('admin_access');

  // Check if user is super admin
  bool get isSuperAdmin => hasPermission('super_admin_access');

  // Get user's role
  Role? get currentRole => _role.value;

  // Set user's role
  set currentRole(Role? role) {
    _role.value = role;
  }

  // Get all available permissions
  List<String> get allPermissions => _permissions;

  // Get permissions grouped by module
  Map<String, List<String>> get permissionsByModule {
    final grouped = <String, List<String>>{};
    for (final permission in _permissions) {
      final module = permission.split('_').first;
      grouped.putIfAbsent(module, () => []).add(permission);
    }
    return grouped;
  }

  // Helper method to check multiple permissions at once
  Map<String, bool> checkMultiplePermissions(List<String> permissions) {
    return {
      for (final permission in permissions)
        permission: hasPermission(permission)
    };
  }

  // Helper method to get denied permissions from a list
  List<String> getDeniedPermissions(List<String> permissions) {
    return permissions.where((permission) => !hasPermission(permission)).toList();
  }

  // Helper method to check if user can perform action
  bool canPerformAction(String module, String action) {
    final permission = '${module}_$action';
    final hasPermission = this.hasPermission(permission);
    
    logger.d(
      'Permission check: $permission = $hasPermission',
      tag: 'Permissions',
    );
    
    return hasPermission;
  }

  // Helper method to validate multiple actions at once
  bool canPerformActions(String module, List<String> actions) {
    return actions.every((action) => canPerformAction(module, action));
  }
}

// Extension for easy access
extension PermissionServiceExtension on GetInterface {
  PermissionService get permissions => PermissionService.to;
}

// Extension for permission checking on strings
extension PermissionCheckExtension on String {
  bool get hasPermission => Get.find<PermissionService>().hasPermission(this);
}
