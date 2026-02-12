import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/theme/fonts.dart';

class CustomDropDownButtomFormField extends StatelessWidget {
  final double? inputFieldWidth;
  final double? inputFieldHeigt;
  final InputBorder? inputBorder;
  final bool? isDense;
  final bool? filled;
  final String? hintText;
  final GlobalKey? formKey;
  final dynamic prefixIcon;
  final dynamic sufixIcon;
  final bool? isPassword;
  final bool? isRequired;
  final dynamic customValidationFunction;
  final List<DropdownMenuItem>? dropDownMenuItems;

  dynamic dropDownValue;

  ///////////////
  TextEditingController? controller;
  TextInputType textInputType;
  String? labelText;
  Widget? suffix;
  bool? isEnabled;
  bool readOnly;
  bool obscureText;
  final Function? validator;
  bool onlyText;
  bool onlyNumber;
  int? maxLine;
  int? minLine;
  int? maxLength;
  bool? prefixText;
  Color? fillColor;
  Function()? onTap;
  Function? onChanged;
  Function? onFieldSubmitted;
  String? initialValue;
  bool? isFromSearch;
  bool? autoFocus;
  AutovalidateMode? autovalidateMode;
  List<String> autoFillHint;
  bool searchString;
  bool fullNameString;
  bool? showBorder;
  TextInputAction? textInputAction;
  double borderRadius;
  double? hintTextSize;
  FontWeight? hintTextWeight;
  double? enteredTextSize;
  FontWeight? enteredTextWeight;
  TextAlign? textAlignment;
  bool? notFromFormType = false;
  CustomDropDownButtomFormField({
    super.key,
    this.dropDownValue,
    this.inputFieldWidth,
    this.inputFieldHeigt,
    this.inputBorder,
    this.isDense,
    this.hintText,
    this.formKey,
    this.prefixIcon,
    this.sufixIcon,
    this.isRequired,
    this.isPassword,
    this.filled,
    this.customValidationFunction,
    this.dropDownMenuItems,
    ////
    this.controller,
    this.textInputType = TextInputType.text,
    this.labelText,
    this.suffix,
    this.isEnabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.onlyText = false,
    this.onlyNumber = false,
    this.maxLine = 1,
    this.minLine = 1,
    this.maxLength,
    this.prefixText,
    this.fillColor = const Color(0xffF4F4F4),
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.isFromSearch = false,
    this.autoFocus = false,
    this.autovalidateMode,
    this.autoFillHint = const [],
    this.searchString = false,
    this.fullNameString = false,
    this.textInputAction,
    this.showBorder,
    this.borderRadius = 20,
    this.hintTextSize,
    this.hintTextWeight,
    this.enteredTextSize,
    this.enteredTextWeight,
    this.textAlignment,
    this.notFromFormType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: inputFieldWidth ?? double.maxFinite,
      child: DropdownButtonFormField(
        isDense: true,
        value: dropDownValue,
        items: dropDownMenuItems ?? [],
        validator: (value) {
          if (value == null) {
            return (isRequired == true) ? "" : null;
          }
          return null;
        },
        onChanged: (value) {
          dropDownValue = value;
        },
        autovalidateMode:
            autovalidateMode ?? AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: filled,
          isDense: true,
          contentPadding: notFromFormType == true ? EdgeInsets.zero : null,
          labelStyle: TextStyle(
            fontFamily: appFont,
            color: AppColor.kNeutral500,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          errorStyle: TextStyle(
            fontSize: 10.0,
            fontFamily: appFont,
          ),
          hintStyle: TextStyle(
            fontFamily: appFont,
            color: AppColor.kNeutral500,
            fontSize: hintTextSize ?? 12,
            fontWeight: hintTextWeight ?? FontWeight.w400,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: Colors.grey,
                )
              : null,
          fillColor: filled == true ? fillColor : null,
          hintText: hintText,
          labelText: labelText,
          suffixIcon: suffix,
          enabledBorder: filled == true || showBorder == false
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: AppColor.kTextFormFieldBorder,
                  ),
                ),
          border: filled == true
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: AppColor.kTextFormFieldBorder,
                  ),
                ),
          focusedBorder: filled == true || showBorder == false
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: AppColor.kTextFormFieldBorder,
                  ),
                ),
        ),
      ),
    );
  }
}
