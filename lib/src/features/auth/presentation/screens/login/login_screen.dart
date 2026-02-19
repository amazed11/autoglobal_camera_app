import 'package:autoglobal_camera_app/src/core/app/medias.dart';
import 'package:autoglobal_camera_app/src/core/configs/route_config.dart';
import 'package:autoglobal_camera_app/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autoglobal_camera_app/src/utils/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../di_injection.dart';
import '../../../../../core/app/colors.dart';
import '../../../../../utils/custom_toasts.dart';
import '../../../../../widgets/custom_dialogs.dart';
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
          // Dismiss any loading dialog if present
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          errorToast(msg: state.message);
        }
        if (state.status == AuthStatus.success) {
          // Dismiss any loading dialog if present
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          successToast(msg: state.message);
          context.pushReplacement(RouteConfig.mainRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo or Title
                Image.asset(
                  kLogoImage,
                  width: 120,
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Welcome back! Please sign in to continue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Quicksand',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Form
                Form(
                  key: getIt<AuthCubit>().formKey,
                  child: const LoginFormWidget(),
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (getIt<AuthCubit>().isFormValid()) {
                        unfocusKeyboard(context);
                        getIt<AuthCubit>().login();
                      } else {
                        warningToast(msg: 'Please fill all required fields');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kPrimaryMain,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
