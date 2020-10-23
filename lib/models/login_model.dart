// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.statusCode,
    this.accessToken,
    this.tokenType,
  });

  int statusCode;
  String accessToken;
  String tokenType;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        statusCode: json["status_code"],
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "access_token": accessToken,
        "token_type": tokenType,
      };
}
