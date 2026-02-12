import 'package:autoglobal_camera_app/src/features/auth/presentation/screens/register/widgets/register_form_widget.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../di_injection.dart';
import '../../../../../core/app/dimensions.dart';
import '../../../../../core/app/texts.dart';
import '../../../../../core/configs/route_config.dart';
import '../../../../../core/routing/route_generator.dart';
import '../../../../../core/routing/route_navigation.dart';
import '../../../../../utils/custom_toasts.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_dialogs.dart';
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> userTypes = [
    "Car Washer",
    "Car Tester",
    "Insurance Agent",
    "Finance Agent",
  ];
  String? selectedType;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.loading) {
          CustomDialogs.fullLoadingDialog(
              context: context, data: state.message);
        }
        if (state.status == RegisterStatus.failure) {
          back(context);
          errorToast(msg: state.message);
        }
        if (state.status == RegisterStatus.success) {
          back(context);
          successToast(msg: state.message);
          AppRouter().clearAndNavigate(RouteConfig.mainRoute);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (_pageController.page == 0) {
                  context.pop();
                }
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left_rounded),
            ),
          ),
          body: Container(
            padding: screenLeftRightPadding,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable swipe to change page
              children: [
                _buildUserTypeSelection(),
                _buildFormPage(),
                _buildOtpConfirmationPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSizedBox1,
        CustomText.ourText(
          "Please select your type to proceed further",
          color: Colors.grey,
        ),
        const Text(
          "Hello, I'm ",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        vSizedBox2,
        Expanded(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return vSizedBox2;
            },
            shrinkWrap: true,
            itemCount: userTypes.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: selectedType == userTypes[index]
                      ? Border.all(color: Colors.green, width: 1)
                      : Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectedType = userTypes[index];
                    });
                  },
                  leading: selectedType == userTypes[index]
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  title: Text(userTypes[index]),
                ),
              );
            },
          ),
        ),
        vSizedBox3,
        CustomButton.elevatedButton(
          "Next",
          () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        vSizedBox2,
      ],
    );
  }

  Widget _buildFormPage() {
    return ListView(
      children: [
        vSizedBox1,
        const Text(
          "User Details",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Form(
          key: getIt<RegisterCubit>().formKey,
          child: const RegisterFormWidget(),
        ),
        vSizedBox3,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton.textButton(
              "Previous",
              () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            CustomButton.elevatedButton(
              "Submit",
              () {
                // _pageController.nextPage(
                //   duration: const Duration(milliseconds: 300),
                //   curve: Curves.easeInOut,
                // );
                if (getIt<RegisterCubit>().isFormValid()) {
                  getIt<RegisterCubit>().register();
                } else {
                  warningToast(msg: pleaseFillText);
                }
              },
            ),
          ],
        ),
        vSizedBox2,
      ],
    );
  }

  Widget _buildOtpConfirmationPage() {
    return Column(
      children: [
        vSizedBox1,
        const Text(
          "OTP Confirmation",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        vSizedBox2,
        // Example OTP field
        Form(
          key: getIt<RegisterCubit>().otpKey,
          child: CustomTextFormField(
            hintText: "Enter OTP",
          ),
        ),
        vSizedBox3,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton.textButton(
              "Previous",
              () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            CustomButton.elevatedButton(
              "Confirm",
              () {},
            ),
          ],
        ),
        vSizedBox2,
      ],
    );
  }
}
