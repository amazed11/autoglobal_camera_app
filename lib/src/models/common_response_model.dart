import 'dart:convert';

CommonResponseModel<T> commonResponseModelFromJson<T>(
  String str, {
  T Function(dynamic json)? fromData,
}) =>
    CommonResponseModel<T>.fromJson(
      json.decode(str),
      fromData: fromData,
    );

String commonResponseModelToJson<T>(
  CommonResponseModel<T> data, {
  dynamic Function(T data)? toData,
}) =>
    json.encode(data.toJson(toData: toData));

class CommonResponseModel<T> {
  final dynamic status;
  final dynamic message;
  final T? data;
  final int? total;
  final int? pageSize;
  final int? currentPage;
  final String? next;
  final String? prev;

  CommonResponseModel({
    this.status,
    this.message,
    this.data,
    this.total,
    this.pageSize,
    this.currentPage,
    this.next,
    this.prev,
  });

  factory CommonResponseModel.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromData,
  }) =>
      CommonResponseModel(
        status: json["status"] ?? json["success"],
        message: json["message"],
        data: fromData != null && json["data"] != null
            ? fromData(json["data"])
            : json["data"] as T?,
        total: json["total"],
        pageSize: json["page_size"],
        currentPage: json["current_page"],
        next: json["next"],
        prev: json["prev"],
      );

  bool get isSuccess {
    if (status is bool) {
      return status as bool;
    }

    if (status is num) {
      return (status as num) == 1;
    }

    final value = status?.toString().toLowerCase();
    return value == "success" || value == "true" || value == "1";
  }

  Map<String, dynamic> toJson({dynamic Function(T data)? toData}) => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : toData != null
                ? toData(data as T)
                : data,
        "total": total,
        "page_size": pageSize,
        "current_page": currentPage,
        "next": next,
        "prev": prev,
      };
}
