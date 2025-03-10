import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> children;
  final List<Widget>? actions;
  final EdgeInsets padding;
  final EdgeInsets? contentPadding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool hasShadow;
  final double borderRadius;

  const CustomCard({
    super.key,
    this.title,
    this.titleWidget,
    required this.children,
    this.actions,
    this.padding = const EdgeInsets.all(16),
    this.contentPadding,
    this.width,
    this.height,
    this.backgroundColor,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.hasShadow = true,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (title != null || titleWidget != null || actions != null)
            _buildHeader(),
          if (isLoading)
            _buildLoading()
          else if (errorMessage != null)
            _buildError()
          else
            Padding(
              padding: contentPadding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisSize: mainAxisSize,
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (titleWidget != null)
              titleWidget!
            else if (title != null)
              Text(
                title!,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (actions != null) ...[
              Row(
                children: actions!,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;
  final Widget? trailing;
  final bool showArrow;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.subtitle,
    this.trailing,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 40, color: color),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward,
                    color: color.withOpacity(0.5),
                  ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List<InfoItem> items;
  final VoidCallback? onEdit;
  final bool isLoading;
  final String? errorMessage;

  const InfoCard({
    super.key,
    required this.title,
    required this.items,
    this.onEdit,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: title,
      actions: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
      ],
      isLoading: isLoading,
      errorMessage: errorMessage,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      item.label,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: item.value is Widget
                        ? item.value as Widget
                        : Text(
                            item.value.toString(),
                            style: Get.textTheme.bodyMedium,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class InfoItem {
  final String label;
  final dynamic value;

  const InfoItem({
    required this.label,
    required this.value,
  });
}
