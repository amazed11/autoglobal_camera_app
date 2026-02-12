class OTPRequestModel {
  final String email;
  final String to;

  OTPRequestModel({
    required this.email,
    required this.to,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "to": to,
    };
  }
}
