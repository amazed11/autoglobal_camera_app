import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/texts.dart';

void showNetworkMaterialBanner(BuildContext context) {
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: const Text(turnOnDataOrWifiText),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      backgroundColor: const Color.fromARGB(255, 55, 39, 39),
      leadingPadding: const EdgeInsets.only(right: 30),
      leading: Icon(
        Icons.wifi_off_outlined,
        size: 32,
        color: AppColor.kPrimaryDark,
      ),
      actions: [
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearMaterialBanners();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child: const Text(okText)),
      ]));
}
