// To parse this JSON data, do
//
//     final instDetailsModel = instDetailsModelFromJson(jsonString);

import 'dart:convert';

InstDetailsModel instDetailsModelFromJson(String str) =>
    InstDetailsModel.fromJson(json.decode(str));

String instDetailsModelToJson(InstDetailsModel data) =>
    json.encode(data.toJson());

class InstDetailsModel {
  InstDetailsModel({
    this.institute,
  });

  Institute institute;

  factory InstDetailsModel.fromJson(Map<String, dynamic> json) =>
      InstDetailsModel(
        institute: Institute.fromJson(json["institute"]),
      );

  Map<String, dynamic> toJson() => {
        "institute": institute.toJson(),
      };
}

class Institute {
  Institute({
    this.id,
    this.name,
    this.address,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String address;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
