import 'dart:convert';

class RegistrationRequest {
  RegistrationRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  String email;
  String password;
  String confirmPassword;

  factory RegistrationRequest.fromRawJson(String str) =>
      RegistrationRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      RegistrationRequest(
        email: json["email"],
        password: json["password"],
        confirmPassword: json["confirm_password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
      };
}
