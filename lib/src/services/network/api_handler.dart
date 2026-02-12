import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../core/app/texts.dart';
import '../../core/configs/api_config.dart';
import '../../core/development/console.dart';
import '../../core/error/api_exceptions.dart';
import '../../features/main/data/models/upload_image/upload_image_request_model.dart';
import '../local/shared_preferences.dart';

@singleton
class ApiHandler {
  static const int timeOutDuration = 60;
  final Map<String, String> _headers = {
    "Content-Type": applicationJsonText,
    "Accept": applicationJsonText
  };

  late final Dio _dio;

  ApiHandler() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: timeOutDuration),
        receiveTimeout: const Duration(seconds: timeOutDuration),
        headers: _headers,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  //DELETE
  Future<dynamic> delete(String api,
      {dynamic payloadObj, bool isauth = true}) async {
    var token = SharedPreference.getToken();
    String? payload;
    if (payloadObj != null) {
      payload = json.encode(payloadObj);
    }
    try {
      var response = await _dio.delete(
        api,
        data: payload,
        options: Options(
          headers: isauth
              ? {
                  "Content-Type": applicationJsonText,
                  "Accept": applicationJsonText,
                  "Authorization": "Bearer $token"
                }
              : _headers,
        ),
      );
      consolelog(response.data);
      consolelog(api);
      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
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
    var url = isCustomApi ? api : api;
    try {
      String? token;
      if (isauth ?? false) {
        token = SharedPreference.getToken();
      }

      console("The API is: ${ApiConfig.baseUrl}$url");
      var response = await _dio.get(
        url,
        options: Options(
          headers: header ??
              {
                "Content-Type": applicationJsonText,
                "Accept": applicationJsonText,
                if (isauth ?? false) "Authorization": "Bearer $token"
              },
        ),
      );
      console("Response Status Code: ${response.statusCode}");
      consolelog(response.data);
      consolelog("$context :::: ${ApiConfig.baseUrl}$url");
      consolelog("$bearerText $token");
      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, url);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, url);
      } else {
        rethrow;
      }
    }
  }

//PATCH
  Future<dynamic> patch(String api,
      {dynamic payloadObj, bool? isauth = true}) async {
    console(api);
    try {
      var payload = json.encode(payloadObj);
      console("payload $payload");
      var token = SharedPreference.getToken();
      var response = await _dio.patch(
        api,
        data: payload,
        options: Options(
          headers: isauth == true
              ? {
                  "Content-Type": applicationJsonText,
                  "Accept": applicationJsonText,
                  "Authorization": "Bearer $token"
                }
              : _headers,
        ),
      );
      consolelog(response.data);
      consolelog(payload);
      consolelog(api);
      consolelog("Bearer $token");
      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
    }
  }

  //PUT
  Future<dynamic> put(String api, dynamic payloadObj,
      {bool? isauth = true}) async {
    var payload = json.encode(payloadObj);
    var token = SharedPreference.getToken();
    try {
      var response = await _dio.put(
        api,
        data: payload,
        options: Options(
          headers: isauth == true
              ? {
                  "Content-Type": applicationJsonText,
                  "Accept": applicationJsonText,
                  "Authorization": "Bearer $token"
                }
              : _headers,
        ),
      );
      consolelog(response.data);
      consolelog(payload);
      consolelog(api);
      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
    }
  }

  //POST
  Future<dynamic> post(
    String api,
    dynamic payloadObj, {
    bool? isauth = true,
    bool? checkout = false,
    Map<String, String>? checkoutHeader,
    Map<String, String>? header,
    bool? isCustomApi = false,
  }) async {
    var url = isCustomApi == true ? api : api;
    console(url);
    var payload = json.encode(payloadObj);
    console("payload $payload");
    try {
      var token = SharedPreference.getToken();

      var response = await _dio.post(
        url,
        data: payload,
        options: Options(
          headers: checkout == true
              ? checkoutHeader
              : isauth == true
                  ? {
                      "Content-Type": applicationJsonText,
                      "Accept": "application/json",
                      "Authorization": "Bearer $token"
                    }
                  : _headers,
        ),
      );
      consolelog(response.data);
      consolelog(payload);
      consolelog(url);
      consolelog(response.headers);
      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, url);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, url);
      } else {
        rethrow;
      }
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
    try {
      var token = SharedPreference.getToken();

      FormData formData = FormData();

      if (file != null) {
        formData.files.add(MapEntry(
          "$imageKey",
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last,
              contentType: DioMediaType('image', 'jpg')),
        ));
      }

      Map<String, String> serializedData = {};
      payloadObj?.forEach((key, value) {
        if (value is String) {
          serializedData[key] = value;
        } else {
          serializedData[key] = json.encode(value);
        }
      });
      formData.fields
          .addAll(serializedData.entries.map((e) => MapEntry(e.key, e.value)));

      var response = await _dio.request(
        api,
        data: formData,
        options: Options(
          method: method,
          headers:
              isauth == true ? {"Authorization": "Bearer $token"} : _headers,
        ),
      );

      consolelog("File: ${file?.path}");
      consolelog("Payload: $payloadObj");
      consolelog("Api Url: $api");
      console("Status Code: ${response.statusCode}");
      consolelog("Response Body: ${response.data}");

      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
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
    UploadImageRequestModel? uploadImageRequestModel,
  }) async {
    try {
      var token = SharedPreference.getToken();
      FormData formData = FormData();

      if ((files?.isNotEmpty ?? false)) {
        for (var data in files!) {
          for (var e in data.entries) {
            final base64Image = await addBase64Image(e.value);
            formData.fields.add(MapEntry(e.key, base64Image));
          }
        }
      }

      Map<String, String> serializedData = {};
      payloadObj?.forEach((key, value) {
        if (value is String) {
          serializedData[key] = value;
        } else {
          serializedData[key] = json.encode(value);
        }
      });
      formData.fields
          .addAll(serializedData.entries.map((e) => MapEntry(e.key, e.value)));

      var response = await _dio.request(
        api,
        data: formData,
        options: Options(
          method: method,
          headers: isauth == true
              ? {"Accept": "application/json", "Authorization": "Bearer $token"}
              : _headers,
        ),
      );

      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
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
    try {
      var token = SharedPreference.getToken();
      FormData formData = FormData();

      if (file1 != null) {
        formData.files.add(MapEntry(
          "$image1Key",
          await MultipartFile.fromFile(file1.path,
              filename: file1.path.split('/').last,
              contentType: MediaType('image', 'jpg')),
        ));
      }
      if (file2 != null) {
        formData.files.add(MapEntry(
          "$image2Key",
          await MultipartFile.fromFile(file2.path,
              filename: file2.path.split('/').last,
              contentType: MediaType('image', 'jpg')),
        ));
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

      formData.fields
          .addAll(serializedData.entries.map((e) => MapEntry(e.key, e.value)));

      var response = await _dio.request(
        api,
        data: formData,
        options: Options(
          method: method,
          headers: isauth == true
              ? {"Authorization": "$bearerText $token"}
              : _headers,
        ),
      );
      consolelog(api);
      consolelog(response.data);

      return processResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ApiNotRespondingException(apiNotRespondingText, api);
      } else if (e.type == DioExceptionType.connectionError) {
        throw FetchDataException(noInternetConnectionText, api);
      } else {
        rethrow;
      }
    }
  }

  dynamic processResponse(Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 304:
        return response.data.toString();

      default:
        throw ApiException(
          response.data["message"] ?? "Something went wrong",
          response.requestOptions.uri.toString(),
        );
    }
  }
}
