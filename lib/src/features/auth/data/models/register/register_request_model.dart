class RegisterRequestModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;

  RegisterRequestModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
  });
  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "password": password,
      };
}
