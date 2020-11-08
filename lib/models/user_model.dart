// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.username,
    this.emailVerifiedAt,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String username;
  dynamic emailVerifiedAt;
  String apiToken;
  DateTime createdAt;
  DateTime updatedAt;
  String role;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        emailVerifiedAt: json["email_verified_at"],
        apiToken: json["api_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "username": username,
        "email_verified_at": emailVerifiedAt,
        "api_token": apiToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "role": role,
      };
}
