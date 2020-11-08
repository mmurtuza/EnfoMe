// To parse this JSON data, do
//
//     final subsModel = subsModelFromJson(jsonString);

import 'dart:convert';

SubsModel subsModelFromJson(String str) => SubsModel.fromJson(json.decode(str));

String subsModelToJson(SubsModel data) => json.encode(data.toJson());

class SubsModel {
  SubsModel({
    this.institutes,
  });

  List<Institute> institutes;

  factory SubsModel.fromJson(Map<String, dynamic> json) => SubsModel(
        institutes: List<Institute>.from(
            json["institutes"].map((x) => Institute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "institutes": List<dynamic>.from(institutes.map((x) => x.toJson())),
      };
}

class Institute {
  Institute({
    this.id,
    this.name,
    this.type,
    this.address,
  });

  String id;
  String name;
  String type;
  String address;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "address": address,
      };
}
