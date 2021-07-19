import 'dart:convert';

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  String oldPassword;
  String newPassword;
  String confirmPassword;

  factory ChangePasswordRequest.fromRawJson(String str) =>
      ChangePasswordRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequest(
        oldPassword: json["old_password"],
        newPassword: json["new_password"],
        confirmPassword: json["confirm_password"],
      );

  Map<String, dynamic> toJson() => {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };
}
