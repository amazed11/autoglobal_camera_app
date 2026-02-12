class VerifyOtpRequestModel {
  final String? transaction;
  final String? otp;
  final String? type;
  final bool? isFromRegister;

  VerifyOtpRequestModel({
    this.transaction,
    this.otp,
    required this.isFromRegister,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        "transaction": transaction,
        "otp": otp,
        "type": type,
      };
}
