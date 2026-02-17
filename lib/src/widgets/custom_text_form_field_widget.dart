import 'package:autoglobal_camera_app/src/core/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffix;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLength;
  final TextInputType? textInputType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffix,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.hintText,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.style,
    this.maxLength,
    this.textInputType,
  }) : assert(
          prefixIcon == null || prefixWidget == null,
          'Cannot provide both prefixIcon and prefixWidget',
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textAlign: textAlign,
      style: style,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.kPrimaryMain, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.kError, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.kError, width: 2.0),
        ),
        prefixIcon:
            prefixWidget ?? (prefixIcon != null ? Icon(prefixIcon) : null),
        suffixIcon: suffix,
      ),
    );
  }
}
