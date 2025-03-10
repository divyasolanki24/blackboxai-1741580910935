import 'package:get/get.dart';
import 'package:shop_management_system/services/api_service.dart';
import 'package:shop_management_system/services/storage_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    // Initialize StorageService first as other services might depend on it
    final storageService = await Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    });

    // Initialize ApiService with auth token from storage
    Get.put<ApiService>(
      ApiService(authToken: storageService.getAuthToken()),
      permanent: true,
    );

    // Register other global dependencies here
    // For example, you might want to register global controllers or services
    // that need to be available throughout the app lifecycle

    // Example:
    // Get.put<GlobalController>(GlobalController(), permanent: true);
    // Get.put<ThemeController>(ThemeController(), permanent: true);
    // Get.put<NavigationController>(NavigationController(), permanent: true);
  }

  // Helper method to reinitialize ApiService with new token
  static void reinitializeApiService(String? token) {
    // Remove existing ApiService instance
    Get.delete<ApiService>();
    
    // Create new instance with updated token
    Get.put<ApiService>(
      ApiService(authToken: token),
      permanent: true,
    );
  }

  // Helper method to clear all services on logout
  static void clearServices() async {
    final storageService = Get.find<StorageService>();
    
    // Clear storage
    await storageService.clearAll();
    
    // Reinitialize ApiService without token
    reinitializeApiService(null);
    
    // Clear any other services or controllers that need to be reset
    // Example:
    // Get.delete<UserController>();
    // Get.delete<CartController>();
  }
}
