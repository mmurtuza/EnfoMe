import 'package:enfome/views/instListType.dart';
import 'package:flutter/material.dart';
import 'package:enfome/views/home.dart';
import 'package:enfome/views/loginPage.dart';
import 'package:enfome/views/signUp.dart';

final routes = {
  LoginPage.routeName: (BuildContext context) => new LoginPage(),
  Home.routeName: (BuildContext context) => new Home(),
  SignUp.routeName: (BuildContext context) => new SignUp(),
  InstituteListType.routeName: (BuildContext context) =>
      new InstituteListType(),
};
