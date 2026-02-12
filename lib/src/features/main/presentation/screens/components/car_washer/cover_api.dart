import 'dart:convert';
import 'dart:io';

import 'package:autoglobal_camera_app/src/widgets/custom_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis_auth/auth_io.dart';

class GoogleVisionService {
  Future<vision.VisionApi> _getVisionApi() async {
    await dotenv.load();
    final serviceAccountJson = dotenv.env['GOOGLE_SERVICE_ACCOUNT_JSON'];
    if (serviceAccountJson == null) {
      throw Exception('GOOGLE_SERVICE_ACCOUNT_JSON not found in .env');
    }
    final credentials = json.decode(serviceAccountJson);
    var accountCredentials =
        auth.ServiceAccountCredentials.fromJson(credentials);

    final scopes = [vision.VisionApi.cloudPlatformScope];
    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);

    return vision.VisionApi(authClient);
  }

  Future<bool> detectLabels(File imageFile, BuildContext context) async {
    CustomDialogs.fullLoadingDialog(
        context: context, data: "Processing image please wait...");
    final visionApi = await _getVisionApi();
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final requests = vision.BatchAnnotateImagesRequest(requests: [
      vision.AnnotateImageRequest(
        image: vision.Image(content: base64Image),
        features: [vision.Feature(type: 'LABEL_DETECTION', maxResults: 10)],
      ),
    ]);

    final response = await visionApi.images.annotate(requests);
    final labelAnnotations = response.responses?.first.labelAnnotations;
    CustomDialogs.cancelDialog(context);
    final data =
        labelAnnotations?.map((label) => label.description).toList() ?? [];
    print("data: $data");
    bool containsCar =
        data.any((word) => word?.toLowerCase().contains("car") ?? false);
    if (containsCar) {
      return true;
    } else {
      CustomDialogs.showNoCarDialog(context);
      return false;
    }
  }
}
