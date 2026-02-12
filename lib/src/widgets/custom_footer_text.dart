import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/custom_launch_url.dart';

class CustomFooterText extends StatelessWidget {
  const CustomFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "By continuing, you accept to our ",
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Quicksand',
          ),
          children: [
            TextSpan(
              text: "Terms of Service",
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                color: Colors.black54,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => CustomUrlLaunch.launch(
                    "https://ipatco.com/terms-of-service"),
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy.",
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    CustomUrlLaunch.launch("https://ipatco.com/privacy-policy"),
            ),
          ]),
    );
  }
}
