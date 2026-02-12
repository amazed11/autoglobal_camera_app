import 'package:flutter/material.dart';

import '../../../../../../../../di_injection.dart';
import '../../../../../../core/app/dimensions.dart';
import '../../../../../../widgets/custom_text_form_field_widget.dart';
import '../../../cubit/auth_cubit.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSizedBox1,
        CustomTextFormField(
          hintText: "Enter email",
          labelText: "Email",
          prefixIcon: Icons.email_outlined,
          controller: getIt<AuthCubit>().emailController,
          validator: (val) => getIt<AuthCubit>().isEmailValid(val),
          textInputType: TextInputType.emailAddress,
        ),
        vSizedBox2,
        CustomTextFormField(
          hintText: "Enter password",
          labelText: "Password",
          obscureText: !isPasswordVisible,
          prefixIcon: Icons.lock_outline,
          controller: getIt<AuthCubit>().passwordController,
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
          validator: (val) => getIt<AuthCubit>().isPasswordValid(val),
        ),
      ],
    );
  }
}
