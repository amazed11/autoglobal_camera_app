// To parse this JSON data, do
//
//     final uploadImageRequestModel = uploadImageRequestModelFromJson(jsonString);

import 'dart:convert';

UploadImageRequestModel uploadImageRequestModelFromJson(String str) =>
    UploadImageRequestModel.fromJson(json.decode(str));

String uploadImageRequestModelToJson(UploadImageRequestModel data) =>
    json.encode(data.toJson());

class UploadImageRequestModel {
  final dynamic carId;
  final String? coverImage;
  final List<String>? exteriorImages;
  final List<String>? interiorImages;
  final List<String>? otherImages;

  UploadImageRequestModel({
    this.coverImage,
    this.carId = "9c6eb191-b946-478a-ad4b-87eaf29d17d3",
    this.exteriorImages,
    this.interiorImages,
    this.otherImages,
  });

  factory UploadImageRequestModel.fromJson(Map<String, dynamic> json) =>
      UploadImageRequestModel(
        coverImage: json["cover_image"],
        exteriorImages: json["exterior_images"] == null
            ? []
            : List<String>.from(json["exterior_images"]!.map((x) => x)),
        interiorImages: json["interior_images"] == null
            ? []
            : List<String>.from(json["interior_images"]!.map((x) => x)),
        otherImages: json["other_images"] == null
            ? []
            : List<String>.from(json["other_images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cover_image": coverImage,
        "exterior_images": exteriorImages == null
            ? []
            : List<dynamic>.from(exteriorImages!.map((x) => x)),
        "interior_images": interiorImages == null
            ? []
            : List<dynamic>.from(interiorImages!.map((x) => x)),
        "other_images": otherImages == null
            ? []
            : List<dynamic>.from(otherImages!.map((x) => x)),
      };
}
