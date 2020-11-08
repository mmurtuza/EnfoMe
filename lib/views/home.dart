import 'package:enfome/views/instituteList.dart';
import 'package:enfome/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:enfome/views/feed.dart';
import 'package:enfome/views/meet.dart';
import 'package:enfome/models/user_model.dart';
import 'package:enfome/util/networkUtil.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:enfome/util/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:enfome/views/createPost.dart';
import 'package:enfome/views/notification.dart';
import 'package:enfome/views/subscriptions.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Future fetchUser;
  final storage = FlutterSecureStorage();
  bool isAdmin = false, mailVarified = true;

  int notiNo = 0;

  var linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(94, 204, 102, 1),
      Color.fromRGBO(125, 208, 230, 1),
    ],
  );

  // Future<UserDetailModel> _getUser() async {
  //   try {
  //     final response = await http.get(NetworkUtil.userUrl,
  //         headers: {'Authorization': 'Bearer $token'});

  //     if (response.statusCode == 200) {
  //       final res = response.body;
  //     }
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
  Future notiList() async {
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
      var datafromjson = jsonDecode(res);
      notiNo = datafromjson['total_unread'];

      return null;
    } else {
      return null;
    }
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init(
          "ca4ccc0f95f4bbc89a27",
          PusherOptions(
            cluster: "ap1",
          ),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e.message);
    }

    Pusher.connect(onConnectionStateChange: (val) {
      print(val.previousState);
    }, onError: (err) {
      print(err.message);
    });

    Channel _channel = await Pusher.subscribe('my_channel');

    _channel.bind('dfd', (onEvent) {
      print(onEvent.data);
    });
  }

  final List<Widget> _children = [
    Feed(),
    InstituteList(),
    MeetPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  chkToken() async {
    String token = await storage.read(key: 'token');
    if (storage == null) {
      Constrants.pref.setBool('login', false);
      Navigator.pushReplacementNamed(
        context,
        LoginPage.routeName,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this.chkToken();
    this.userFetch();
    fetchUser = userFetch();
    notiList();

    initPusher();
  }

  Future<UserModel> userFetch() async {
    String token = await storage.read(key: 'token');
    try {
      final response = await http.get(NetworkUtil.userUrl, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });
      print('form method  ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final String res = response.body;
        var data = jsonDecode(res);
        if (data['role'] == 'admin') {
          setState(() {
            isAdmin = true;
          });
        }
        if (data["email_verified_at"] == null) {
          setState(() {
            mailVarified = false;
          });
        }
        print('$res');
        return userModelFromJson(res);
      } else {
        return null;
      }
    } catch (e) {
      print('userFetch $e');
    }
  }

  Widget _getIcon() {
    if (notiNo == 0) {
      return Icon(Icons.notifications_none_outlined);
    } else {
      return Icon(Icons.notifications_active_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        //centerTitle: true,
        title: Image.asset(
          'assets/Logo.png',
          fit: BoxFit.scaleDown,
        ),
        actions: <Widget>[
          IconButton(
            icon: _getIcon(),
            onPressed: () {
              Navigator.pushNamed(context, NotificationGrp.routeName);
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
        ),
      ),
      body: _children[_selectedIndex],
      drawer: _drawer(),
      floatingActionButton: isAdmin
          ? _createPost()
          : Container(
              height: 0,
              width: 0,
            ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Future logout() async {
    final response = await http
        .get(NetworkUtil.logoutUrl, headers: {'Accept': 'application/json'});
    print('form method ${response.body}');
    if (response.statusCode == 200) {
      // final String res = response.body;
      // print('From feed $res');
    }
  }

  Widget _createPost() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          CreatePost.routeName,
        );
      },
      child: Icon(Icons.add),
      elevation: 10,
      backgroundColor: Color.fromRGBO(125, 208, 230, 1),
    );
  }

  Widget _drawer() {
    return Drawer(
      elevation: 2,
      child: FutureBuilder(
        future: fetchUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                      snapshot.data.firstName + ' ' + snapshot.data.lastName),
                  accountEmail: Text(snapshot.data.email),
                  currentAccountPicture: CircleAvatar(
                    child: Image.asset(
                      'assets/Logo.png',
                      color: Color.fromRGBO(2, 26, 14, 1),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color.fromRGBO(94, 204, 102, 1),
                        Color.fromRGBO(125, 208, 230, 1),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildUserDialog(context),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    logout();
                    Constrants.pref.setBool('login', false);
                    storage.delete(key: 'token');
                    Navigator.pushReplacementNamed(
                      context,
                      LoginPage.routeName,
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Subscriptions',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  leading: Icon(Icons.subscriptions),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Subscriptions.routeName,
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Notification',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  leading: Icon(Icons.notifications_on),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Home.routeName,
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star_border),
                  title: Text(
                    "Rate Us",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onTap: () {
                    launch(
                        'https://play.google.com/store/apps/details?id=info.enfome.enfome&hl=en');
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                // ListTile(
                //   title: Image.asset(
                //     'assets/Logo.png',
                //     color: Colors.black,
                //   ),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(
                    "+8801313933388",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onTap: () {
                    launch('tel: +8801313933388');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(
                    "enfomebd@gmail.com",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onTap: () {
                    launch('mailto: enfomebd@gmail.com');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(
                    "www.enfome.info",
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  onTap: () {
                    launch('https://www.enfome.info');
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/fb.png'),
                        color: Colors.blue[900],
                      ),
                      //icon: Icon(Icons.face),
                      iconSize: 30.0,
                      onPressed: () {
                        launch('https://www.facebook.com/enfome.info/');
                      },
                    ),
                    IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/images/twitter.png'),
                        color: Colors.blue[400],
                      ),
                      color: Colors.cyan,
                      iconSize: 30.0,
                      onPressed: () {
                        launch('https://www.twiter.com/enf_me/');
                      },
                    ),
                    IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/images/insta.png'),
                        color: Colors.orange[800],
                      ),
                      iconSize: 30.0,
                      onPressed: () {
                        launch('https://www.instagram.com/enfomebd/');
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _bottomBar() {
    var bottomNavigationBarItem = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Feed',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        label: 'Institut',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'E-meet',
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.class_),
      //   label: 'Roll Call',
      // ),
    ];

    return GradientBottomNavigationBar(
      backgroundColorStart: Color.fromRGBO(94, 204, 102, 1),
      backgroundColorEnd: Color.fromRGBO(125, 208, 230, 1),
      items: bottomNavigationBarItem,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      fixedColor: Colors.white,
    );
  }

  Widget _buildUserDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Your Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
              future: fetchUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        child: Image.asset(
                          'assets/Logo.png',
                          color: Colors.green,
                        ),
                        backgroundColor: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Name : ' +
                                snapshot.data.firstName +
                                ' ' +
                                snapshot.data.lastName),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Phone : ' + snapshot.data.phone),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Email : ' + snapshot.data.email),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return AlertDialog(
                      title: Text('else'),
                      content: Container(
                        child: CircularProgressIndicator(),
                      ));
                }
              }),
        ],
      ),
    );
  }
}
