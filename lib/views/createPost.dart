import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:enfome/util/networkUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:enfome/views/home.dart';

// import 'package:dio/dio.dart';
class CreatePost extends StatefulWidget {
  static const String routeName = '/creatPost';

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String postTitle, postBody;
  final storage = FlutterSecureStorage();
  final picker = ImagePicker();
  bool notUploaded = false;

  var file;

  void _choose() async {
    //  file = await ImagePicker.pickImage(source: ImageSource.camera);

    file = await picker.getImage(source: ImageSource.gallery);
  }

  Future _upload() async {
    buildShowDialog(context);

    String token = await storage.read(key: 'token');
    if (file == null) return;
    String fileName = file.path;
    print('$fileName  $postTitle  $postBody');

    final request = http.MultipartRequest(
        'POST', Uri.parse(NetworkUtil.posttUrl))
      ..fields['title'] = postTitle
      ..fields['body'] = postBody
      ..files.add(await http.MultipartFile.fromPath('image', await fileName))
      ..headers['Authorization'] = 'Bearer $token';
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(
        context,
        Home.routeName,
      );
      print('Uploaded!');
    } else {
      setState(() {
        notUploaded = true;
      });
      print(response.statusCode);
    }
    setState(() {
      notUploaded = true;
    });
  }

  var linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color.fromRGBO(94, 204, 102, 1),
      Color.fromRGBO(125, 208, 230, 1),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/Logo.png', fit: BoxFit.cover),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Create New Post',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                style: TextStyle(
                  color: Color.fromRGBO(125, 208, 230, 1),
                ),
                onChanged: (val) {
                  postTitle = val;
                },
                decoration: InputDecoration(
                  hintText: 'Post Title',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(125, 208, 230, 1),
                  ),
                  border: _bord(),
                  enabledBorder: _bord(),
                  focusedBorder: _bord(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 8,
                maxLines: 10,
                style: TextStyle(
                  color: Color.fromRGBO(125, 208, 230, 1),
                ),
                onChanged: (val) {
                  setState(() {
                    postBody = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Your Post',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(125, 208, 230, 1),
                  ),
                  border: _bord(),
                  enabledBorder: _bord(),
                  focusedBorder: _bord(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    disabledTextColor: Color.fromRGBO(125, 208, 230, 1),
                    highlightedBorderColor: Color.fromRGBO(125, 208, 230, 1),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromRGBO(125, 208, 230, 1),
                    ),
                    padding: EdgeInsets.all(10),
                    splashColor: Color.fromRGBO(125, 208, 230, 0.3),
                    onPressed: _choose,
                    child: Text(
                      'Choose Image',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(125, 208, 230, 1),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  OutlineButton(
                    disabledTextColor: Color.fromRGBO(125, 208, 230, 1),
                    highlightedBorderColor: Color.fromRGBO(125, 208, 230, 1),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromRGBO(125, 208, 230, 1),
                    ),
                    padding: EdgeInsets.all(10),
                    splashColor: Color.fromRGBO(125, 208, 230, 0.3),
                    onPressed: _upload,
                    child: Icon(
                      Icons.send,
                      color: Color.fromRGBO(125, 208, 230, 1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  OutlineInputBorder _bord() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color.fromRGBO(125, 208, 230, 1),
        width: 2,
      ),
    );
  }
}
