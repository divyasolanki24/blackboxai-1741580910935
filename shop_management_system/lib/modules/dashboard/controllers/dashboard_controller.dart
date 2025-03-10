import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shop_management_system/core/theme/theme_service.dart';
import 'package:shop_management_system/models/activity.dart';

class DashboardController extends GetxController {
  final ThemeService _themeService = ThemeService();
  
  // Observable variables for stats
  final totalSales = 156789.0;
  final totalProducts = 1234;
  final totalShops = 45;
  final activeUsers = 789;
  
  // Theme mode tracking
  final isDarkMode = false.obs;

  // Sales data for the line chart
  final List<FlSpot> salesData = [
    const FlSpot(0, 3000),
    const FlSpot(1, 4000),
    const FlSpot(2, 3500),
    const FlSpot(3, 5000),
    const FlSpot(4, 4800),
    const FlSpot(5, 6000),
    const FlSpot(6, 5500),
  ];

  // Recent activities data
  final List<Activity> recentActivities = [
    Activity(
      icon: Icons.shopping_cart,
      color: Colors.green,
      title: 'New Order #1234',
      subtitle: 'Order placed by John Doe',
      time: '2 mins ago',
    ),
    Activity(
      icon: Icons.inventory,
      color: Colors.orange,
      title: 'Low Stock Alert',
      subtitle: 'Product ID: PRD-567',
      time: '15 mins ago',
    ),
    Activity(
      icon: Icons.person,
      color: Colors.blue,
      title: 'New User Registration',
      subtitle: 'Jane Smith joined',
      time: '1 hour ago',
    ),
    Activity(
      icon: Icons.store,
      color: Colors.purple,
      title: 'New Shop Added',
      subtitle: 'Shop ID: SHP-890',
      time: '2 hours ago',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize theme mode
    isDarkMode.value = Get.isDarkMode;
  }

  void toggleTheme() {
    _themeService.switchTheme();
    isDarkMode.value = !isDarkMode.value;
  }
}
