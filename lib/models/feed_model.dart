import 'dart:convert';

FeedModel feedModelFromJson(String str) => FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  FeedModel({
    this.news,
  });

  List<News> news;

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "news": List<dynamic>.from(news.map((x) => x.toJson())),
      };
}

class News {
  News({
    this.id,
    this.title,
    this.body,
    this.image,
    this.link,
    this.instituteId,
  });

  int id;
  String title;
  String body;
  String image;
  String link;
  String instituteId;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        image: json["image"],
        link: json["link"],
        instituteId: json["institute_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "image": image,
        "link": link,
        "institute_id": instituteId,
      };
}
