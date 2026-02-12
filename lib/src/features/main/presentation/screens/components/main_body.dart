import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/core/app/medias.dart';
import 'package:autoglobal_camera_app/src/core/configs/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../widgets/custom_text.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AG General App'),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                context.pushNamed(RouteConfig.carWasherRoute);
              },
              dense: true,
              title: CustomText.ourText(
                "Car Washer",
                fontWeight: FontWeight.bold,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              subtitle: const Text(
                "You can click all the pictures after cleaning as per instructions",
              ),
              leading: Image.asset(kCleaner),
            ),
            vSizedBox2,
            ListTile(
              onTap: () {
                context.pushNamed(RouteConfig.carTesterRoute);
                // warningToast(msg: "It's under development");
              },
              dense: true,
              title: CustomText.ourText(
                "Car Tester",
                fontWeight: FontWeight.bold,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              subtitle: const Text(
                "You can check performance of car as per instructions",
              ),
              leading: Image.asset(kTester),
            ),
          ],
        ),
      ),
    );
  }
}
