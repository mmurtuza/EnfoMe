import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enfome/util/networkUtil.dart';
import 'package:enfome/models/subsModel.dart';

class Subscriptions extends StatefulWidget {
  static const String routeName = '/subscription';
  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final storage = FlutterSecureStorage();
  Future<SubsModel> subsFetch;

  Future<SubsModel> subsList() async {
    String token = await storage.read(key: 'token');
    // print('from future $token');
    final response = await http.get(NetworkUtil.subsUrl, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    print('form method ${response.body}');
    if (response.statusCode == 200) {
      final String res = response.body;
      print('From feed ${subsModelFromJson(res)}');
      return subsModelFromJson(res);
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
    subsFetch = subsList();
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
            subsFetch = subsList();
          });
          return subsFetch;
        },
        child: new FutureBuilder(
          future: subsFetch,
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
                                snapshot.data.institutes[index].name,
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
                itemCount: snapshot.data.institutes == null
                    ? 0
                    : snapshot.data.institutes.length,
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
