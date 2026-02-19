import 'dart:convert';

CarPermissionModel carPermissionModelFromJson(String str) =>
    CarPermissionModel.fromJson(json.decode(str));

String carPermissionModelToJson(CarPermissionModel data) =>
    json.encode(data.toJson());

class CarPermissionModel {
  final dynamic status;
  final CarPermissionData? data;

  CarPermissionModel({
    this.status,
    this.data,
  });

  factory CarPermissionModel.fromJson(Map<String, dynamic> json) =>
      CarPermissionModel(
        status: json['status'],
        data: json['data'] == null
            ? null
            : CarPermissionData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}

class CarPermissionData {
  final int carId;
  final bool canUploadImages;
  final bool canUploadDamage;
  final bool canUploadPaint;
  final bool canUploadDocument;
  final bool canUploadOptions;

  const CarPermissionData({
    required this.carId,
    required this.canUploadImages,
    required this.canUploadDamage,
    required this.canUploadPaint,
    required this.canUploadDocument,
    required this.canUploadOptions,
  });

  factory CarPermissionData.fromJson(Map<String, dynamic> json) =>
      CarPermissionData(
        carId: json['car_id'] ?? 0,
        canUploadImages: json['can_upload_images'] == true,
        canUploadDamage: json['can_upload_damage'] == true,
        canUploadPaint: json['can_upload_paint'] == true,
        canUploadDocument: json['can_upload_document'] == true,
        canUploadOptions: json['can_upload_options'] == true,
      );

  Map<String, dynamic> toJson() => {
        'car_id': carId,
        'can_upload_images': canUploadImages,
        'can_upload_damage': canUploadDamage,
        'can_upload_paint': canUploadPaint,
        'can_upload_document': canUploadDocument,
        'can_upload_options': canUploadOptions,
      };
}
