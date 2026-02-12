import 'package:flutter/material.dart';

import '../core/app/dimensions.dart';

class CustomHeaderOnboarding extends StatelessWidget {
  const CustomHeaderOnboarding({this.title, this.desc, super.key});
  final String? title;
  final String? desc;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // vSizedBox1,
        // Text(
        //   title.toString(),
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20,
        //   ),
        // ),
        Text(desc.toString()),
        vSizedBox2,
      ],
    );
  }
}
