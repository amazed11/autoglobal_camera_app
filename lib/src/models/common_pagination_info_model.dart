class CommonPaginationInfoModel {
  int? totalItems;
  int? pages;
  int? limit;
  int? currentPage;
  bool? hasNext;
  bool? hasPrevious;

  CommonPaginationInfoModel({
    this.totalItems,
    this.pages,
    this.limit,
    this.currentPage,
    this.hasNext,
    this.hasPrevious,
  });

  factory CommonPaginationInfoModel.fromJson(Map<String, dynamic> json) =>
      CommonPaginationInfoModel(
        totalItems: json["totalItems"],
        pages: json["pages"],
        limit: json["limit"],
        currentPage: json["currentPage"],
        hasNext: json["hasNext"],
        hasPrevious: json["hasPrevious"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "pages": pages,
        "limit": limit,
        "currentPage": currentPage,
        "hasNext": hasNext,
        "hasPrevious": hasPrevious,
      };
}
