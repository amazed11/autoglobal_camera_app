import 'package:autoglobal_camera_app/src/core/app/texts.dart';
import 'package:autoglobal_camera_app/src/utils/validation.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../di_injection.dart';
import '../../../../../../core/app/dimensions.dart';
import '../../../../../../widgets/custom_text_form_field_widget.dart';
import '../cubit/register_cubit.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => RegisterFormWidgetState();
}

class RegisterFormWidgetState extends State<RegisterFormWidget> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSizedBox1,
        CustomTextFormField(
          hintText: "Enter first name",
          labelText: "First name",
          prefixIcon: Icons.person_outline,
          controller: getIt<RegisterCubit>().firstNameController,
          validator: (val) => val.toString().isEmptyData() ? emptyText : null,
          textInputType: TextInputType.text,
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter Last name",
          labelText: "Last name",
          prefixIcon: Icons.person_outline,
          controller: getIt<RegisterCubit>().lastNameController,
          validator: (val) => val.toString().isEmptyData() ? emptyText : null,
          textInputType: TextInputType.text,
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter phone",
          labelText: "Phone",
          prefixIcon: Icons.call,
          controller: getIt<RegisterCubit>().phoneController,
          validator: (val) => val.toString().isEmptyData() ? emptyText : null,
          textInputType: TextInputType.phone,
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter email",
          labelText: "Email",
          prefixIcon: Icons.email_outlined,
          controller: getIt<RegisterCubit>().emailController,
          validator: (val) => getIt<RegisterCubit>().isEmailValid(val),
          textInputType: TextInputType.emailAddress,
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter password",
          labelText: "Password",
          obscureText: !isPasswordVisible,
          prefixIcon: Icons.lock_outline,
          controller: getIt<RegisterCubit>().passwordController,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: isPasswordVisible == false
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
          ),
          validator: (val) => getIt<RegisterCubit>().isPasswordValid(
              val, getIt<RegisterCubit>().confirmPasswordController),
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter confirm password",
          labelText: "Confirm Password",
          obscureText: !isConfirmPasswordVisible,
          prefixIcon: Icons.lock_outline,
          controller: getIt<RegisterCubit>().confirmPasswordController,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                isConfirmPasswordVisible = !isConfirmPasswordVisible;
              });
            },
            icon: isConfirmPasswordVisible == false
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
          ),
          validator: (val) => getIt<RegisterCubit>()
              .isPasswordValid(val, getIt<RegisterCubit>().passwordController),
        ),
      ],
    );
  }
}
