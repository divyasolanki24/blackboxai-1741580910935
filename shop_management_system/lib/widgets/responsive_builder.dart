import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile() => Get.width < 850;
  static bool isTablet() => Get.width >= 850 && Get.width < 1100;
  static bool isDesktop() => Get.width >= 1100;

  @override
  Widget build(BuildContext context) {
    if (isDesktop() && desktop != null) {
      return desktop!;
    }
    if (isTablet() && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
