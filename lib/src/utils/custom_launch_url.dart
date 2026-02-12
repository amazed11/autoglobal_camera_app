import 'custom_toasts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomUrlLaunch {
  static Future<void> launch(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        errorToast(msg: "Could not launch");
        throw "couldnotLaunchText $url";
      }
    } catch (e) {
      errorToast(msg: "Could not launch");
    }
  }

  static Future<void> launchEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: "mailTo",
      path: email,
    );
    try {
      if (!await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      )) {
        errorToast(msg: "Could not launch");
        throw "couldnotLaunchText $email";
      }
    } catch (e) {
      errorToast(msg: "Could not launch");
    }
  }

  static Future<void> makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      errorToast(msg: "Couldn't find contact number");
      return;
    }
    final Uri launchUri = Uri(
      scheme: "tel",
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
