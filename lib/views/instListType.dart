import 'package:enfome/models/instDetailsModel.dart';
import 'package:enfome/models/reg_model.dart';
import 'package:enfome/util/networkUtil.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InstituteListType extends StatefulWidget {
  static const String routeName = '/instList';
  static String typeofInst;
  @override
  _InstituteListTypeState createState() => _InstituteListTypeState();
}

class _InstituteListTypeState extends State<InstituteListType> {
  // List instituteList = List();
  // List<String> sInstituteList;
  final storage = FlutterSecureStorage();
  Future<InstituteListModel> fu;
  int instId;
  Future<InstDetailsModel> _instDetailvar;
  bool chkSbs;

  Future<InstituteListModel> instList() async {
    String token = await storage.read(key: 'token');
    String url = NetworkUtil.instListUrl + InstituteListType.typeofInst;
    print(url);
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      print('inli ${response.statusCode}');
      if (response.statusCode == 200) {
        final String res = response.body;
        // var resBody = jsonDecode(res);
        // print(resBody);
        try {
          return instituteListModelFromJson(res);
        } catch (e) {
          print(e);
          return null;
        }
      } else {
        print('err');
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<InstDetailsModel> instDetail() async {
    String token = await storage.read(key: 'token');
    String url = NetworkUtil.instDetailstUrl + instId.toString();
    print(url);
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      print('inli ${response.statusCode}');
      if (response.statusCode == 200) {
        final String res = response.body;
        Map resBody = jsonDecode(res);
        print(resBody);
        try {
          return instDetailsModelFromJson(res);
        } catch (e) {
          print(e);
          return null;
        }
      } else {
        print('err');
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> isSubs() async {
    String token = await storage.read(key: 'token');
    String url = NetworkUtil.subsChkUrl + instId.toString();
    print(url);
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      print('inli ${response.statusCode}');
      if (response.statusCode == 200) {
        final String res = response.body;
        Map resBody = jsonDecode(res);
        print(resBody);
        try {
          if (resBody['status'] == 'subscribed') {
            print('true');
            chkSbs = true;
          } else {
            chkSbs = false;
          }
        } catch (e) {
          print(e);
        }
      } else {
        print('err');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> udateSub() async {
    String token = await storage.read(key: 'token');
    String url = NetworkUtil.updateSubsUrl + instId.toString();
    print(url);
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      print('inli ${response.statusCode}');
      if (response.statusCode == 200) {
        final String res = response.body;
        Map resBody = jsonDecode(res);
        try {
          if (resBody['status'] == 'subscribed') {
            print('true');
            chkSbs = true ? false : true;
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
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
    fu = this.instList();
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
      body: Center(
        child: new FutureBuilder(
          future: fu,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          instId = snapshot.data.institutes[index].id;
                          print(instId);
                          isSubs();
                          print(chkSbs);
                          setState(() {
                            _instDetailvar = instDetail();
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _instDetailsDialog(context),
                          );

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
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _instDetailsDialog(BuildContext context) {
    return AlertDialog(
      // title: const Text('Your Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _instDetailvar,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshot.data.institute.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(125, 208, 230, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: RaisedButton(
                              color: Color.fromRGBO(107, 179, 179, 1),
                              onPressed: udateSub,
                              child: Text(
                                chkSbs ? 'Unsubscrib' : 'Subscrib',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
