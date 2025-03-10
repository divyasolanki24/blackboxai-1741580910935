import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/routes/app_routes.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      
      // TODO: Implement actual login logic here
      // For demo purposes, we'll simulate a delay and successful login
      await Future.delayed(const Duration(seconds: 2));
      
      // Store user token and data
      // await storage.write('token', response.token);
      // await storage.write('user', jsonEncode(response.user));
      
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
