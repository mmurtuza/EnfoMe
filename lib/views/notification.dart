import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enfome/util/networkUtil.dart';
import 'package:enfome/models/subsModel.dart';

class NotificationGrp extends StatefulWidget {
  static const String routeName = '/notification';
  @override
  _NotificationGrpState createState() => _NotificationGrpState();
}

class _NotificationGrpState extends State<NotificationGrp> {
  final storage = FlutterSecureStorage();
  Future<NotiModel> notiFetch;
  int notiNo = 0;

  Future<NotiModel> notiList() async {
    String token = await storage.read(key: 'token');
    // print('from future $token');
    final response = await http.get(NetworkUtil.notiGroupUrl, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    print('form method ${response.body}');
    if (response.statusCode == 200) {
      final String res = response.body;
      // final String res = jsonEncode({
      //   "notifications": ['kjdkdj', 'kjdkf'],
      //   "total_unread": 7
      // });
      print('From feed $res');

      return notiModelFromJson(res);
    } else {
      return null;
    }
  }

  var linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(94, 204, 102, 1),
      Color.fromRGBO(125, 208, 230, 1),
    ],
  );

  @override
  void initState() {
    super.initState();
    notiFetch = notiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        //centerTitle: true,
        title: Image.asset('assets/Logo.png', fit: BoxFit.scaleDown),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            notiFetch = notiList();
          });
          return notiFetch;
        },
        child: new FutureBuilder(
          future: notiFetch,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => FeedView()),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Text(
                                snapshot.data.notifications[index],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(125, 208, 230, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10));
                },
                itemCount: snapshot.data.notifications == null
                    ? 0
                    : snapshot.data.notifications.length,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

NotiModel notiModelFromJson(String str) => NotiModel.fromJson(json.decode(str));

String notiModelToJson(NotiModel data) => json.encode(data.toJson());

class NotiModel {
  NotiModel({
    this.notifications,
    this.totalUnread,
  });

  List<dynamic> notifications;
  int totalUnread;

  factory NotiModel.fromJson(Map<String, dynamic> json) => NotiModel(
        notifications: List<dynamic>.from(json["notifications"].map((x) => x)),
        totalUnread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "notifications": List<dynamic>.from(notifications.map((x) => x)),
        "total_unread": totalUnread,
      };
}
