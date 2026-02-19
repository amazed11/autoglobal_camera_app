import 'dart:convert';

CarOptionsResponse carOptionsResponseFromJson(String str) =>
    CarOptionsResponse.fromJson(json.decode(str));

class CarOptionsResponse {
  final String? status;
  final List<CarOption> data;

  CarOptionsResponse({this.status, this.data = const []});

  factory CarOptionsResponse.fromJson(Map<String, dynamic> json) =>
      CarOptionsResponse(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<CarOption>.from(
                (json['data'] as List).map((x) => CarOption.fromJson(x))),
      );
}

class CarOption {
  final int id;
  final String name;
  final String icon;

  const CarOption({required this.id, required this.name, required this.icon});

  factory CarOption.fromJson(Map<String, dynamic> json) => CarOption(
        id: json['id'] as int,
        name: json['name'] as String,
        icon: json['icon'] as String,
      );

  @override
  bool operator ==(Object other) => other is CarOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
