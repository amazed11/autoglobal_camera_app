import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../di_injection.dart';
import '../../../../../../core/app/colors.dart';
import '../../../../../../core/configs/route_config.dart';
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
        CustomTextFormField(
          hintText: "Enter email",
          labelText: "Email",
          prefixIcon: Icons.email_outlined,
          controller: getIt<AuthCubit>().emailController,
          validator: (val) => getIt<AuthCubit>().isEmailValid(val),
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              context.pushNamed(RouteConfig.forgotPasswordRoute);
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColor.kPrimaryMain,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
