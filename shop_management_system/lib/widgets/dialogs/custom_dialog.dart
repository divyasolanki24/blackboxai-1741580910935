import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  // Confirmation dialog
  static Future<bool> showConfirmation({
    String title = 'Confirm',
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                : confirmColor != null
                    ? ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                      )
                    : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Success dialog
  static Future<void> showSuccess({
    String title = 'Success',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Error dialog
  static Future<void> showError({
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onRetry,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Get.back();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Form dialog
  static Future<T?> showFormDialog<T>({
    required String title,
    required Widget content,
    String submitText = 'Submit',
    String cancelText = 'Cancel',
    bool isDismissible = true,
    Color? submitColor,
    VoidCallback? onSubmit,
  }) async {
    return await Get.dialog<T>(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: onSubmit ?? () => Get.back(),
            style: submitColor != null
                ? ElevatedButton.styleFrom(
                    backgroundColor: submitColor,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(submitText),
          ),
        ],
      ),
      barrierDismissible: isDismissible,
    );
  }

  // Loading dialog
  static void showLoading({
    String message = 'Loading...',
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Custom dialog
  static Future<T?> show<T>({
    required Widget child,
    bool isDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
  }) async {
    return await Get.dialog<T>(
      child,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      useSafeArea: useSafeArea,
    );
  }

  // Bottom sheet dialog
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool expand = false,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDraggable = true,
    bool enableDrag = true,
  }) async {
    return await Get.bottomSheet<T>(
      child,
      backgroundColor: backgroundColor ?? Get.theme.cardColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
    );
  }
}
