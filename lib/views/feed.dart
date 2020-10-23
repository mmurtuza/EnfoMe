import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:enfome/models/feed_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enfome/util/networkUtil.dart';
import 'package:enfome/views/feedVeiw.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final storage = FlutterSecureStorage();
  Future<FeedModel> fetchFeed;

  Future<FeedModel> getFeed() async {
    String token = await storage.read(key: 'token');
    // print('from future $token');
    final response = await http
        .get(NetworkUtil.feedUrl, headers: {'Authorization': 'Bearer $token'});
    // print('form method ${response.body}');
    if (response.statusCode == 200) {
      final String res = response.body;
      // print('From feed ${feedModelFromJson(res)}');
      return feedModelFromJson(res);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeed = getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new FutureBuilder(
        future: fetchFeed,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FeedView()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text(
                              snapshot.data.news[index].title,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(125, 208, 230, 1),
                              ),
                            ),
                            new Image.network(
                              'https://enfome.info/storage/app/' +
                                  snapshot.data.news[index].image,
                              height: 200,
                              fit: BoxFit.fitWidth,
                            ),
                            new Text(
                              snapshot.data.news[index].body,
                              style: TextStyle(
                                color: Color.fromRGBO(125, 208, 230, 1),
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10));
              },
              itemCount:
                  snapshot.data.news == null ? 0 : snapshot.data.news.length,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
