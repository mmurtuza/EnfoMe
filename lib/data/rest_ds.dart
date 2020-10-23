import 'package:enfome/util/networkUtil.dart';
import 'package:enfome/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RestDatasource {
  static final baseUrl = "https://dev.enfome.info/api";
  static final loginUrl = baseUrl + "/login";

  Future<LoginModel> createLogin(String email, String password) async {
    print("I have been called");
    final response = await http.post(loginUrl, body: {
      "email": email,
      "password": password,
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      print('$response.body');
      final String res = response.body;
      return loginModelFromJson(res);
    } else {
      return null;
    }
  }
}
