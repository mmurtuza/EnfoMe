import 'package:enfome/util/constants.dart';
import 'package:enfome/views/home.dart';
import 'package:enfome/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart';
import 'package:enfome/util/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:enfome/views/notification.dart';

// void main() {
//   runApp(DevicePreview(
//     builder: (context) => new MyApp(),
//   ));
// }
Future<void> main() async {
  final storage = FlutterSecureStorage();
  if (storage == null) {
    Constrants.pref.setBool('login', false);
  }

  WidgetsFlutterBinding.ensureInitialized();
  Constrants.pref = await SharedPreferences.getInstance();
//Bellow 3 lines are for debug purpus only.
  // runApp(DevicePreview(
  //   builder: (context) => new MyApp(),
  // ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "EnfoMe",
      theme: new ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Constrants.pref.getBool('login') == true ? Home() : LoginPage(),
      routes: routes,
    );
  }
}
