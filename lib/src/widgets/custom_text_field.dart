import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app/colors.dart';
import '../core/configs/regex_config.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController? controller;
  dynamic formKey;
  String? hintText;
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
  IconData? prefixIcon;
  Function()? onTap;
  Function? onChanged;
  Function? onFieldSubmitted;
  String? initialValue;
  bool? isSearch;
  bool? autoFocus;
  AutovalidateMode? autovalidateMode;
  List<String> autoFillHint;
  bool searchString;
  bool fullNameString;
  bool allowMultipleSpace;
  TextInputAction? textInputAction;
  double borderRadius;
  double? hintTextSize;
  FontWeight? hintTextWeight;
  double? enteredTextSize;
  FontWeight? enteredTextWeight;
  TextAlign? textAlignment;
  bool? notFromFormType = false;
  bool? allowDouble;
  dynamic prefixIconSize;

  CustomTextField({
    Key? key,
    this.formKey,
    this.controller,
    this.hintText,
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
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.isSearch = false,
    this.autoFocus = false,
    this.autovalidateMode,
    this.autoFillHint = const [],
    this.searchString = false,
    this.fullNameString = false,
    this.allowMultipleSpace = true,
    this.textInputAction,
    this.borderRadius = 10,
    this.hintTextSize,
    this.hintTextWeight,
    this.enteredTextSize,
    this.enteredTextWeight,
    this.textAlignment,
    this.notFromFormType,
    this.allowDouble,
    this.prefixIconSize = 22.0,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final focusNode = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              hasFocus ? AppColor.kPrimaryMain : AppColor.kTextFormFieldBorder,
        ),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      child: TextFormField(
        textAlign: widget.textAlignment ?? TextAlign.left,
        minLines: widget.minLine,
        maxLines: widget.maxLine,
        maxLength: widget.maxLength,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autoFillHint,
        validator: (value) {
          return widget.validator == null ? null : widget.validator!(value);
        },
        style: TextStyle(
          color: widget.readOnly ? Colors.grey : null,
          fontSize: widget.enteredTextSize ?? 16,
          fontFamily: "Urbanist",
          fontWeight: widget.enteredTextWeight ?? FontWeight.w400,
        ),
        inputFormatters: widget.onlyNumber
            ? [
                FilteringTextInputFormatter.allow(RegexConfig.numberRegex),
                FilteringTextInputFormatter.deny(
                  RegexConfig.stopConsecutiveSpace,
                ),
              ]
            : widget.onlyText
                ? [
                    FilteringTextInputFormatter.allow(RegexConfig.textRegex),
                    FilteringTextInputFormatter.deny(
                      RegexConfig.stopConsecutiveSpace,
                    ),
                  ]
                : widget.searchString
                    ? [
                        FilteringTextInputFormatter.allow(
                            RegexConfig.searchRegrex),
                        FilteringTextInputFormatter.deny(
                          RegexConfig.stopConsecutiveSpace,
                        ),
                      ]
                    : widget.fullNameString
                        ? [
                            FilteringTextInputFormatter.allow(
                                RegexConfig.fullNameTextRegrex),
                            FilteringTextInputFormatter.deny(
                              RegexConfig.stopConsecutiveSpace,
                            ),
                          ]
                        : widget.allowMultipleSpace == false
                            ? [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'\s{2}'),
                                ),
                              ]
                            : widget.allowDouble == false
                                ? [
                                    FilteringTextInputFormatter.allow(
                                      RegexConfig.doubleRegExp,
                                    ),
                                  ]
                                : [
                                    FilteringTextInputFormatter.deny(
                                      RegexConfig.stopConsecutiveSpace,
                                    ),
                                  ],
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        enabled: widget.isEnabled,
        onTap: widget.onTap,
        onChanged: (val) =>
            widget.isSearch == true ? widget.onChanged!(val) : null,
        onFieldSubmitted: (val) =>
            widget.isSearch == true ? widget.onFieldSubmitted!(val) : null,
        autovalidateMode:
            widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            prefixText: widget.prefixText == true ? " +977 " : null,
            prefixStyle: TextStyle(
              fontFamily: "Urbanist",
              color: AppColor.kNeutral500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.zero,
            labelStyle: TextStyle(
              fontFamily: "Urbanist",
              color: AppColor.kNeutral500,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            errorStyle: const TextStyle(
              fontSize: 10.0,
              fontFamily: "Urbanist",
            ),
            hintStyle: TextStyle(
              fontFamily: "Urbanist",
              // fontSize: 16.0,
              color: AppColor.kNeutral500,
              fontSize: widget.hintTextSize ?? 15,
              fontWeight: widget.hintTextWeight ?? FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: Colors.grey,
                    size: widget.prefixIconSize,
                  )
                : null,
            hintText: widget.hintText,
            labelText: widget.labelText,
            suffixIcon: widget.suffix,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
        focusNode: focusNode,
      ),
    );
  }
}
