import 'package:enfome/util/constants.dart';
import 'package:enfome/views/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_particles/particles.dart';
import 'package:flutter/services.dart';
import 'package:enfome/util/networkUtil.dart';
import 'package:enfome/models/login_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enfome/util/routes.dart';
import 'package:enfome/views/home.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  String msg = null;
  bool _isLoading = false;
  bool _autoValidate = false;
  Color _getColor1 = Color.fromRGBO(94, 204, 102, 1.0);
  Color _getColor2 = Color.fromRGBO(94, 204, 102, 1.0);
  var _op1 = 0.0;
  var _op2 = 0.0;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  UniqueKey _f1, f2;

  LoginModel _login;

  Future<LoginModel> createLogin(String email, String password) async {
    try {
      final response = await http.post(NetworkUtil.loginUrl, body: {
        "email": email,
        "password": password,
      }, headers: {
        'Accept': 'application/json'
      });

      print(response.statusCode);
      if (response.statusCode == 200) {
        final String res = response.body;
        return loginModelFromJson(res);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _submit() async {
    setState(() => _isLoading = true);
    final form = _formKey.currentState;

    print('wait ${Constrants.pref.getBool('login')}');

    try {
      if (form.validate()) {
        setState(() => _isLoading = true);
        form.save();

        try {
          final LoginModel login = await createLogin(email, password);
          print(login.statusCode);

          if (login.statusCode == 200) {
            final storage = new FlutterSecureStorage();
            await storage.delete(key: 'token');
            await storage.write(key: 'token', value: login.accessToken);
            Constrants.pref.setBool('login', true);
            Navigator.pushReplacementNamed(context, Home.routeName);
          } else if (login.statusCode == 404) {
            setState(() {
              msg = 'Check your internet connection!';
              _isLoading = false;
            });
            return null;
          } else if (login.statusCode == 500) {
            setState(() {
              msg = 'Server error try again after some time!';
              _isLoading = false;
            });
            return null;
          } else {
            print('${Constrants.pref.getBool('login')}');
            print('error');
            setState(() => _isLoading = false);
          }
        } on Exception catch (e) {
          print(e);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print(e);
    }
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      print(" $email  $password");
    } else {
//    If all data are not valid then start auto validation.
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  String validatePass(String value) {
    if (value != password) {
      return 'Password don\'t match';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Particles(35, Colors.white.withOpacity(0.4)),
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 450.0,
                minHeight: 700.0,
              ),
              // child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    msg != null
                        ? Text(
                            msg,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    _errorMsg(),
                    emailField(),
                    SizedBox(
                      height: 25.0,
                    ),
                    passwordField(),
                    SizedBox(
                      height: 50.0,
                    ),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _loginButton(),
                    Spacer(
                        // height: 70,
                        ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Forget Password? Recover Password',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SignUp.routeName,
                              );
                              // Route route = MaterialPageRoute(
                              //     builder: (context) => SignUp());
                              // Navigator.push(context, route);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              //),
              // ),
              //),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailField() {
    return Container(
      key: _f1,
      clipBehavior: Clip.hardEdge,
      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(94, 204, 102, _op1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        onTap: () {
          setState(() {
            _op1 = 1.0;
            _getColor1 = Color.fromRGBO(2, 26, 14, 1.0);
          });
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(94, 204, 102, _op1),
          border: InputBorder.none,
          hintText: 'Eenter Your E-mail',
          hintStyle: TextStyle(
            color: _getColor1,
          ),
        ),
        style: TextStyle(
          fontSize: 15.0,
          color: _getColor1,
        ),
        validator: validateEmail,
        onChanged: validateEmail,
        onSaved: (newValue) {
          return email = newValue;
        },
      ),
      // ),
    );
  }

  Widget passwordField() {
    return Container(
      key: f2,
      clipBehavior: Clip.hardEdge,
      // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(94, 204, 102, _op2),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        onTap: () {
          setState(() {
            _op2 = 1.0;
            _getColor2 = Color.fromRGBO(2, 26, 14, 1.0);
          });
        },
        obscureText: _obscureText,
        validator: (val) {
          return val.length < 6 ? "Password must have atleast 6 chars" : null;
        },
        onChanged: validatePass,
        onSaved: (val) {
          return password = val;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(94, 204, 102, _op2),
          border: InputBorder.none,
          hintText: 'Eenter Your Password',
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: _getColor2,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: _getColor2,
            ),
          ),
        ),
        style: TextStyle(
          color: _getColor2,
        ),
      ),
      // ),
    );
  }

  Widget _loginButton() {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: _submit,
        child: Text(
          'LOG IN',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        color: Color.fromRGBO(94, 204, 102, 1.0),
        textColor: Color.fromRGBO(2, 26, 14, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget _errorMsg() {
    return msg == null
        ? Container(
            height: 0,
            width: 0,
          )
        : Container(
            child: Text(
              msg,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          );
  }
}
