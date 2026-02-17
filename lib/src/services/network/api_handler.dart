import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../core/app/texts.dart';
import '../../core/configs/api_config.dart';
import '../../core/development/console.dart';
import '../../core/error/api_exceptions.dart';
import '../local/shared_preferences.dart';

@singleton
class ApiHandler {
  static const int timeOutDuration = 60;
  final Map<String, String> _headers = {
    "Content-Type": applicationJsonText,
    "Accept": applicationJsonText
  };

  //DELETE
  Future<dynamic> delete(String api,
      {dynamic payloadObj, bool isauth = true}) async {
    var uri = Uri.parse(ApiConfig.baseUrl + api);
    var token = SharedPreference.getToken();
    String? payload;
    if (payloadObj != null) {
      payload = json.encode(payloadObj);
    }
    try {
      var response = await http
          .delete(uri,
              body: payload,
              headers: isauth == true
                  ? {
                      "Content-Type": applicationJsonText,
                      "Accept": applicationJsonText,
                      "Authorization": "Bearer $token"
                    }
                  : _headers)
          .timeout(const Duration(seconds: timeOutDuration));
      consolelog(response.body);
      consolelog(uri);
      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  //GET
  Future<dynamic> get(
    String api, {
    Map<String, String>? header,
    bool? isauth = false,
    bool isCustomApi = false,
    String? context,
  }) async {
    var uri = isCustomApi == true
        ? Uri.parse(api.toString())
        : Uri.parse(ApiConfig.baseUrl + api);
    try {
      String? token;
      if (isauth ?? false) {
        token = SharedPreference.getToken();
      }

      console("The API is: $uri");
      var response = await http
          .get(
            uri,
            headers: header ??
                {
                  "Content-Type": applicationJsonText,
                  "Accept": applicationJsonText,
                  if (isauth ?? false) "Authorization": "Bearer $token"
                },
          )
          .timeout(const Duration(seconds: timeOutDuration));
      console("Response Status Code: ${response.statusCode}");
      consolelog(response.body);
      consolelog("$context :::: $uri");
      consolelog("$bearerText $token");
      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

//PATCH
  Future<dynamic> patch(String api,
      {dynamic payloadObj, bool? isauth = true}) async {
    var uri = Uri.parse(ApiConfig.baseUrl + api);
    console(uri);
    try {
      var payload = json.encode(payloadObj);
      console("payload $payload");
      var token = SharedPreference.getToken();
      var response = await http
          .patch(uri,
              body: payload,
              headers: isauth == true
                  ? {
                      "Content-Type": applicationJsonText,
                      "Accept": applicationJsonText,
                      "Authorization": "Bearer $token"
                    }
                  : _headers)
          .timeout(const Duration(seconds: timeOutDuration));
      consolelog(response.body);
      consolelog(payload);
      consolelog(uri);
      consolelog("Bearer $token");
      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  //PUT
  Future<dynamic> put(String api, dynamic payloadObj,
      {bool? isauth = true}) async {
    var uri = Uri.parse(ApiConfig.baseUrl + api);
    var payload = json.encode(payloadObj);
    var token = SharedPreference.getToken();
    try {
      var response = await http
          .put(uri,
              body: payload,
              headers: isauth == true
                  ? {
                      "Content-Type": applicationJsonText,
                      "Accept": applicationJsonText,
                      "Authorization": "Bearer $token"
                    }
                  : _headers)
          .timeout(const Duration(seconds: timeOutDuration));
      consolelog(response.body);
      consolelog(payload);
      consolelog(uri);
      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  //POST
  Future<dynamic> post(
    String api,
    dynamic payloadObj, {
    bool? isauth = true,
    bool? isCustomAuthHeader = false,
    Map<String, String>? customAuthHeader,
    Map<String, String>? header,
    bool? isCustomApi = false,
  }) async {
    var uri = isCustomApi == true
        ? Uri.parse(api.toString())
        : Uri.parse(ApiConfig.baseUrl + api);
    console(uri);
    var payload = json.encode(payloadObj);
    console("payload $payload");
    try {
      var token = SharedPreference.getToken();

      var response = await http
          .post(
            uri,
            body: payload,
            headers: isCustomAuthHeader == true
                ? customAuthHeader
                : isauth == true
                    ? {
                        "Content-Type": applicationJsonText,
                        "Accept": "application/json",
                        "Authorization": "Bearer $token"
                      }
                    : _headers,
          )
          .timeout(
            const Duration(seconds: timeOutDuration),
          );
      consolelog(response.body);
      consolelog(payload);
      consolelog(uri);
      consolelog(response.headers);
      return processResponse(response);
    } on SocketException catch (e) {
      console(e.toString());
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  Future<dynamic> postWithImage(
    String api, {
    dynamic payloadObj,
    File? file,
    String method = 'POST',
    String? imageKey,
    Map<String, String>? header,
    bool? isauth = false,
  }) async {
    var uri = Uri.parse(
      ApiConfig.baseUrl + api,
    );

    try {
      var token = SharedPreference.getToken();
      // var token = SharedPreference.getToken();

      var request = http.MultipartRequest(method, uri);
      request.headers.addAll(
        isauth == true
            ? {
                "Content-Type": applicationJsonText,
                "Authorization": "Bearer $token"
              }
            : _headers,
      );
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath("$imageKey", file.path,
              contentType: MediaType('image', 'jpg')),
        );
      }
      Map<String, String> serializedData = {};
      payloadObj?.forEach((key, value) {
        if (value is String) {
          serializedData[key] = value;
        } else {
          serializedData[key] = json.encode(value);
        }
      });
      request.fields.addAll(serializedData);
      var data = await request.send();
      var response = await http.Response.fromStream(data);
      consolelog("File: ${file?.path}");
      consolelog("Payload: $payloadObj");
      consolelog("Api Url: $uri");
      console("Status Code: ${response.statusCode}");
      consolelog("Response Body: ${response.body}");

      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  Future<String> addBase64Image(File file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);
    return base64Image;
  }

  Future<dynamic> postWithMultipleImage(
    String api, {
    Map<String, dynamic>? payloadObj,
    List<Map<String, File>>? files,
    String method = 'POST',
    Map<String, String>? header,
    bool? isauth = false,
  }) async {
    var uri = Uri.parse(
      ApiConfig.baseUrl + api,
    );
    try {
      var token = SharedPreference.getToken();
      var request = http.MultipartRequest(method, uri);
      request.headers.addAll(
        isauth == true
            ? {"Accept": "application/json", "Authorization": "Bearer $token"}
            : _headers,
      );
      Map<String, String> serializedData = {};

      if ((files?.isNotEmpty ?? false)) {
        for (var data in files!) {
          for (var e in data.entries) {
            final base64Image = await addBase64Image(e.value);
            request.fields[e.key] = base64Image;
          }
        }
      }

      payloadObj?.forEach((key, value) {
        if (value is String) {
          serializedData[key] = value;
        } else {
          serializedData[key] = json.encode(value);
        }
      });

      request.fields.addAll(serializedData);

      var data = await request.send();
      var response = await http.Response.fromStream(data);

      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  Future<dynamic> postWithImages(
    String api, {
    Map<String, dynamic>? payloadObj,
    File? file1,
    File? file2,
    String method = 'POST',
    String? image1Key,
    String? image2Key,
    Map<String, String>? header,
    bool? isauth = false,
  }) async {
    var uri = Uri.parse(
      ApiConfig.baseUrl + api,
    );
    try {
      var token = SharedPreference.getToken();
      var request = http.MultipartRequest(method, uri);
      request.headers.addAll(
        isauth == true
            ? {
                "Content-Type": applicationJsonText,
                "Authorization": "$bearerText $token"
              }
            : _headers,
      );
      if (file1 != null) {
        request.files.add(
          await http.MultipartFile.fromPath("$image1Key", file1.path,
              contentType: MediaType('image', 'jpg')),
        );
      }
      if (file2 != null) {
        request.files.add(
          await http.MultipartFile.fromPath("$image2Key", file2.path,
              contentType: MediaType('image', 'jpg')),
        );
      }

      Map<String, String> serializedData = {};
      payloadObj?.forEach((key, value) {
        if (value is String) {
          serializedData[key] = value;
        } else {
          serializedData[key] = json.encode(value);
        }
      });

      consolelog(serializedData);

      request.fields.addAll(serializedData);

      var data = await request.send();
      var response = await http.Response.fromStream(data);
      consolelog(uri);
      consolelog(response.body);

      return processResponse(response);
    } on SocketException {
      throw FetchDataException(noInternetConnectionText, uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(apiNotRespondingText, uri.toString());
    }
  }

  dynamic retryOriginalRequest(http.Request request) async {
    try {
      print("i am retry http after token refresh");
      // Retry the original request with the updated access token
      var refreshedResponse = await request.send();
      var bodyBytes = await refreshedResponse.stream.toBytes();
      // Create an http.Response object from the response data
      var retryResponse = http.Response.bytes(
        bodyBytes,
        refreshedResponse.statusCode,
        headers: refreshedResponse.headers,
        request: refreshedResponse.request,
      );
      // Return the response
      return retryResponse.bodyBytes.toString();
    } catch (error) {
      // Handle errors
      print('Error occurred during retrying original request: $error');
      throw Exception('Error occurred during retrying original request');
    }
  }

  dynamic processResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 304:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson.toString();

      default:
        throw ApiException(
          json.decode(response.body)["message"] ?? "Something went wrong",
          response.request?.url.toString(),
        );
    }
  }
}
