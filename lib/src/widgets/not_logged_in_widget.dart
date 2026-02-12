import 'package:flutter/material.dart';
import '../core/app/dimensions.dart';
import '../core/app/texts.dart';

import 'custom_button.dart';
import 'custom_text.dart';

class NotLoggedWidget extends StatelessWidget {
  const NotLoggedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(),
          vSizedBox2,
          CustomText.ourText(haventLoggedInText, fontWeight: FontWeight.bold),
          vSizedBox1,
          CustomText.ourText(loginText, fontSize: 12),
          vSizedBox1,
          CustomButton.elevatedButton(
            'Login',
            () {
              // navigateOffAllNamed(context, RouteConfig.loginRoute);
            },
            borderRadius: 20,
          )
        ],
      ),
    );
  }
}
