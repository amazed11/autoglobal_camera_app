import 'dart:convert';

CarResponseModel carResponseModelFromJson(String str) =>
    CarResponseModel.fromJson(json.decode(str));

String carResponseModelToJson(CarResponseModel data) =>
    json.encode(data.toJson());

class CarResponseModel {
  final dynamic status;
  final List<CarModel> data;
  final int total;
  final int pageSize;
  final int currentPage;
  final String? next;
  final String? prev;

  CarResponseModel({
    required this.status,
    required this.data,
    required this.total,
    required this.pageSize,
    required this.currentPage,
    required this.next,
    required this.prev,
  });

  factory CarResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return CarResponseModel(
      status: json['status'],
      data: list
          .map((item) => CarModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      next: json['next'],
      prev: json['prev'],
    );
  }

  bool get hasMore => next != null && next!.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.map((item) => item.toJson()).toList(),
        'total': total,
        'page_size': pageSize,
        'current_page': currentPage,
        'next': next,
        'prev': prev,
      };
}

class CarModel {
  final int id;
  final String? image;
  final String? dbClassification;
  final String? chasissNumber;
  final String? carManufacturer;
  final String? model;
  final String? carLabel;
  final int? year;
  final String? exteriorColor;
  final String? interiorColor;
  final String? fuelType;
  final String? transmissionType;
  final String? city;
  final String? carNumber;
  final String? mileage;
  final String? source;
  final bool favorite;

  CarModel({
    required this.id,
    this.image,
    this.dbClassification,
    this.chasissNumber,
    this.carManufacturer,
    this.model,
    this.carLabel,
    this.year,
    this.exteriorColor,
    this.interiorColor,
    this.fuelType,
    this.transmissionType,
    this.city,
    this.carNumber,
    this.mileage,
    this.source,
    required this.favorite,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      image: json['image'],
      dbClassification: json['db_classification'],
      chasissNumber: json['chasiss_number'],
      carManufacturer: json['car_manufacturer'],
      model: json['model'],
      carLabel: json['car_label'],
      year: json['year'],
      exteriorColor: json['exterior_color'],
      interiorColor: json['interior_color'],
      fuelType: json['fuel_type'],
      transmissionType: json['transmission_type'],
      city: json['city'],
      carNumber: json['car_number'],
      mileage: json['mileage']?.toString(),
      source: json['source'],
      favorite: json['favorite'] == true,
    );
  }

  String get title {
    final maker = carManufacturer?.trim() ?? '';
    final modelName = model?.trim() ?? '';
    final yearText = year != null ? ' $year' : '';
    return '$maker $modelName$yearText'.trim();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'db_classification': dbClassification,
        'chasiss_number': chasissNumber,
        'car_manufacturer': carManufacturer,
        'model': model,
        'car_label': carLabel,
        'year': year,
        'exterior_color': exteriorColor,
        'interior_color': interiorColor,
        'fuel_type': fuelType,
        'transmission_type': transmissionType,
        'city': city,
        'car_number': carNumber,
        'mileage': mileage,
        'source': source,
        'favorite': favorite,
      };
}
