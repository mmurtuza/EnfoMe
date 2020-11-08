import 'package:enfome/views/instListType.dart';
import 'package:flutter/material.dart';
import 'package:enfome/views/home.dart';
import 'package:enfome/views/loginPage.dart';
import 'package:enfome/views/signUp.dart';
import 'package:enfome/views/createPost.dart';
import 'package:enfome/views/subscriptions.dart';
import 'package:enfome/views/notification.dart';

final routes = {
  LoginPage.routeName: (BuildContext context) => new LoginPage(),
  Home.routeName: (BuildContext context) => new Home(),
  SignUp.routeName: (BuildContext context) => new SignUp(),
  InstituteListType.routeName: (BuildContext context) =>
      new InstituteListType(),
  CreatePost.routeName: (BuildContext context) => new CreatePost(),
  Subscriptions.routeName: (BuildContext context) => new Subscriptions(),
  NotificationGrp.routeName: (BuildContext context) => new NotificationGrp(),
};
