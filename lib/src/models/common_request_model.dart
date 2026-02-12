class CommonRequestModel {
  final int? pageNumber;
  final dynamic campaignId;
  final dynamic password;
  final dynamic teamId;
  final String? coupon;
  final dynamic stock;
  final dynamic carNumber;
  final dynamic slug;
  final dynamic page;
  final dynamic limit;
  final String? search;

  CommonRequestModel({
    this.page,
    this.limit,
    this.search,
    this.pageNumber,
    this.campaignId,
    this.carNumber,
    this.teamId,
    this.coupon,
    this.password,
    this.stock,
    this.slug,
  });
}
