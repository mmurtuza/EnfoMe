import 'dart:convert';

RegModel regModelFromJson(String str) => RegModel.fromJson(json.decode(str));

String regModelToJson(RegModel data) => json.encode(data.toJson());

class RegModel {
  RegModel({
    this.token,
  });

  String token;

  factory RegModel.fromJson(Map<String, dynamic> json) => RegModel(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

// To parse this JSON data, do
//
//     final instituteListModel = instituteListModelFromJson(jsonString);

InstituteListModel instituteListModelFromJson(String str) =>
    InstituteListModel.fromJson(json.decode(str));

String instituteListModelToJson(InstituteListModel data) =>
    json.encode(data.toJson());

class InstituteListModel {
  InstituteListModel({
    this.institutes,
  });

  List<Institute> institutes;

  factory InstituteListModel.fromJson(Map<String, dynamic> json) =>
      InstituteListModel(
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

  int id;
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

// To parse this JSON data, do
//
//     final districtsModel = districtsModelFromJson(jsonString);

DistrictsModel districtsModelFromJson(String str) =>
    DistrictsModel.fromJson(json.decode(str));

String districtsModelToJson(DistrictsModel data) => json.encode(data.toJson());

class DistrictsModel {
  DistrictsModel({
    this.districts,
  });

  List<District> districts;

  factory DistrictsModel.fromJson(Map<String, dynamic> json) => DistrictsModel(
        districts: List<District>.from(
            json["districts"].map((x) => District.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
      };
}

class District {
  District({
    this.id,
    this.division,
    this.bengaliName,
    this.englishName,
  });

  String id;
  String division;
  String bengaliName;
  String englishName;

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        division: json["division"],
        bengaliName: json["bengali_name"],
        englishName: json["english_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division": division,
        "bengali_name": bengaliName,
        "english_name": englishName,
      };
}

// To parse this JSON data, do
//
//     final subdistrictsModel = subdistrictsModelFromJson(jsonString);

SubdistrictsModel subdistrictsModelFromJson(String str) =>
    SubdistrictsModel.fromJson(json.decode(str));

String subdistrictsModelToJson(SubdistrictsModel data) =>
    json.encode(data.toJson());

class SubdistrictsModel {
  SubdistrictsModel({
    this.subdistricts,
  });

  List<Subdistrict> subdistricts;

  factory SubdistrictsModel.fromJson(Map<String, dynamic> json) =>
      SubdistrictsModel(
        subdistricts: List<Subdistrict>.from(
            json["subdistricts"].map((x) => Subdistrict.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subdistricts": List<dynamic>.from(subdistricts.map((x) => x.toJson())),
      };
}

class Subdistrict {
  Subdistrict({
    this.id,
    this.districtId,
    this.bengaliName,
    this.englishName,
  });

  String id;
  String districtId;
  String bengaliName;
  String englishName;

  factory Subdistrict.fromJson(Map<String, dynamic> json) => Subdistrict(
        id: json["id"],
        districtId: json["district_id"],
        bengaliName: json["bengali_name"],
        englishName: json["english_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "bengali_name": bengaliName,
        "english_name": englishName,
      };
}
