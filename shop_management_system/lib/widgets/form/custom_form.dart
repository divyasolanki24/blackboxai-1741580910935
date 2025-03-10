import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomForm extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;
  final bool isLoading;
  final String submitText;
  final String cancelText;
  final GlobalKey<FormState> formKey;
  final CrossAxisAlignment crossAxisAlignment;
  final double maxWidth;
  final EdgeInsets padding;

  const CustomForm({
    super.key,
    required this.title,
    required this.children,
    required this.onSubmit,
    required this.formKey,
    this.onCancel,
    this.isLoading = false,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.maxWidth = 600,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Text(
                  title,
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                ...children,
                const SizedBox(height: 32),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onCancel != null) ...[
          OutlinedButton(
            onPressed: isLoading ? null : onCancel,
            child: Text(cancelText),
          ),
          const SizedBox(width: 16),
        ],
        ElevatedButton(
          onPressed: isLoading ? null : () {
            if (formKey.currentState!.validate()) {
              onSubmit();
            }
          },
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(submitText),
        ),
      ],
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool required;
  final AutovalidateMode autovalidateMode;

  const CustomFormField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.required = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${required ? ' *' : ''}',
          style: Get.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            prefixIcon: prefix,
            enabled: enabled,
          ),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return '$label is required';
            }
            return validator?.call(value);
          },
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          autovalidateMode: autovalidateMode,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool required;
  final bool enabled;
  final String? hint;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.required = true,
    this.enabled = true,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${required ? ' *' : ''}',
          style: Get.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: (value) {
            if (required && value == null) {
              return '$label is required';
            }
            return validator?.call(value);
          },
          decoration: InputDecoration(
            enabled: enabled,
            hintText: hint,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CustomCheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;

  const CustomCheckboxField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: value,
      builder: (state) {
        return CheckboxListTile(
          title: Text(label),
          value: value,
          onChanged: enabled ? onChanged : null,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}

class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;
  final bool required;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
    this.required = true,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${required ? ' *' : ''}',
          style: Get.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled
              ? () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(1900),
                    lastDate: lastDate ?? DateTime(2100),
                  );
                  if (date != null) {
                    onChanged(date);
                  }
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              enabled: enabled,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              value != null
                  ? '${value!.day}/${value!.month}/${value!.year}'
                  : 'Select date',
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
