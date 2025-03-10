import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/routes/app_routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).cardColor,
      child: ListView(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Shop Management',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildMenuItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: AppRoutes.DASHBOARD,
          ),
          _buildMenuItem(
            icon: Icons.store_outlined,
            title: 'Shops',
            route: AppRoutes.SHOPS,
          ),
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Products',
            route: AppRoutes.PRODUCTS,
          ),
          _buildMenuItem(
            icon: Icons.inventory_outlined,
            title: 'Inventory',
            route: AppRoutes.INVENTORY,
          ),
          const Divider(),
          _buildMenuItem(
            icon: Icons.people_outline,
            title: 'Users',
            route: AppRoutes.USERS,
          ),
          _buildMenuItem(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Roles',
            route: AppRoutes.ROLES,
          ),
          _buildMenuItem(
            icon: Icons.security_outlined,
            title: 'Permissions',
            route: AppRoutes.PERMISSIONS,
          ),
          _buildMenuItem(
            icon: Icons.extension_outlined,
            title: 'Modules',
            route: AppRoutes.MODULES,
          ),
          const Divider(),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Profile',
            route: AppRoutes.PROFILE,
          ),
          _buildMenuItem(
            icon: Icons.logout_outlined,
            title: 'Logout',
            route: AppRoutes.LOGIN,
            onTap: () {
              // TODO: Implement logout logic
              Get.offAllNamed(AppRoutes.LOGIN);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    VoidCallback? onTap,
  }) {
    final isSelected = Get.currentRoute == route;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Get.theme.primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Get.theme.primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: onTap ?? () => Get.toNamed(route),
    );
  }
}
