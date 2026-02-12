// To parse this JSON data, do
//
//     final otpResponseModel = otpResponseModelFromJson(jsonString);

import 'dart:convert';

OtpResponseModel otpResponseModelFromJson(String str) =>
    OtpResponseModel.fromJson(json.decode(str));

String otpResponseModelToJson(OtpResponseModel data) =>
    json.encode(data.toJson());

class OtpResponseModel {
  final bool? success;
  final String? message;
  final OTPResponseData? data;

  OtpResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      OtpResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : OTPResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class OTPResponseData {
  final String? transactionId;

  OTPResponseData({
    this.transactionId,
  });

  factory OTPResponseData.fromJson(Map<String, dynamic> json) =>
      OTPResponseData(
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
      };
}
