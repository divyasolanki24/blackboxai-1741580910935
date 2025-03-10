import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/core/bindings/app_binding.dart';
import 'package:shop_management_system/core/theme/theme_service.dart';
import 'package:shop_management_system/core/theme/themes.dart';
import 'package:shop_management_system/routes/app_pages.dart';
import 'package:shop_management_system/routes/app_routes.dart';
import 'package:shop_management_system/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app binding
  await initServices();

  runApp(const ShopManagementApp());
}

Future<void> initServices() async {
  // Initialize core services
  await Get.putAsync(() => StorageService().init());
  
  // Initialize app binding
  AppBinding().dependencies();
}

class ShopManagementApp extends StatelessWidget {
  const ShopManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();

    return GetMaterialApp(
      title: 'Shop Management System',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      
      // Initial route based on auth status
      initialRoute: storageService.isLoggedIn() 
        ? AppRoutes.DASHBOARD 
        : AppRoutes.LOGIN,
      
      // Route configuration
      getPages: AppPages.routes,
      
      // Default transition
      defaultTransition: Transition.fade,
      
      // Error handling
      onUnknownRoute: (settings) {
        return GetPageRoute(
          page: () => Scaffold(
            body: Center(
              child: Text(
                'Page not found: ${settings.name}',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
      
      // Locale configuration (if needed)
      // translations: AppTranslations(),
      // locale: Get.deviceLocale,
      // fallbackLocale: const Locale('en', 'US'),
      
      // Global error handling
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          child: child!,
        );
      },
    );
  }
}

// Error widget customization
class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorDetails.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.DASHBOARD);
                },
                child: const Text('Return to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
