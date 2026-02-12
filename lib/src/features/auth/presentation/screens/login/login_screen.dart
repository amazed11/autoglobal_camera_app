import 'package:autoglobal_camera_app/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../di_injection.dart';
import '../../../../../core/app/colors.dart';
import '../../../../../core/app/dimensions.dart';
import '../../../../../core/app/texts.dart';
import '../../../../../core/configs/route_config.dart';
import '../../../../../core/routing/route_navigation.dart';
import '../../../../../utils/custom_toasts.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_dialogs.dart';
import '../../../../../widgets/custom_footer_text.dart';
import '../../../../../widgets/custom_text.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loading) {
          CustomDialogs.fullLoadingDialog(
              context: context, data: state.message);
        }
        if (state.status == AuthStatus.failure) {
          back(context);
          errorToast(msg: state.message);
        }
        if (state.status == AuthStatus.success) {
          back(context);
          successToast(msg: state.message);
          context.pushNamed(RouteConfig.mainRoute);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: CustomText.ourText(
              "Login",
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBar: Container(
            padding: screenLeftRightPadding,
            height: 50,
            child: const CustomFooterText(),
          ),
          body: ListView(
            padding: screenPadding,
            children: [
              vSizedBox2,
              CustomText.ourText(
                "You're Welcome",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              CustomText.ourText(
                "Enter your details to proceed further",
                color: AppColor.kNeutral300,
              ),
              vSizedBox3,
              Form(
                key: getIt<AuthCubit>().formKey,
                child: const LoginFormWidget(),
              ),
              vSizedBox2,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pushNamed(RouteConfig.forgotPasswordRoute);
                    },
                    child: CustomText.ourText(
                      "Forgot Password ?",
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              vSizedBox2,
              CustomButton.elevatedButton(
                "Login",
                () {
                  if (getIt<AuthCubit>().isFormValid()) {
                    getIt<AuthCubit>().login();
                  } else {
                    warningToast(msg: pleaseFillText);
                  }
                },
              ),
              vSizedBox3,
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Quicksand',
                      ),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                context.pushNamed(RouteConfig.registerRoute),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
