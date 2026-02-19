// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String? message;
  User? user;

  LoginResponseModel({
    this.message,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  String? token;
  String? name;
  String? email;
  String? phone;
  String? role;
  bool? needVerification;

  User({
    this.token,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.needVerification,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        needVerification: json["need_verification"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "need_verification": needVerification,
      };
}
