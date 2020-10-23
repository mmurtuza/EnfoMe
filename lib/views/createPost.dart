import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:enfome/util/networkUtil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class CreatePost {
  String postTitle, postBody;
  final storage = FlutterSecureStorage();
  final picker = ImagePicker();

  File file;

  void _choose() async {
    //  file = await ImagePicker.pickImage(source: ImageSource.camera);
    var file = await picker.getImage(source: ImageSource.gallery);
  }

  Future _upload() async {
    Response response;
    Dio dio = new Dio();
    String token = await storage.read(key: 'token');
    if (file == null) return;
    // String base64Image = base64Encode(file.readAsString());
    String fileName = file.path.split("/").last;

    response = await dio.post(
      NetworkUtil.posttUrl,
      data: {
        "title": postTitle,
        "body": postBody,
        "image": await MultipartFile.fromFile(fileName)
      },
      // options: Options(headers: {'Authorization': 'Bearer $token'})
    );

    // final request =
    //     http.MultipartRequest('POST', Uri.parse(NetworkUtil.posttUrl));
    // request.files.add(await http.MultipartFile.fromPath("image", fileName));
    // var res = await request.send();
    // return res.reasonPhrase;

    //   http.post(NetworkUtil.posttUrl, headers: {
    //     'Authorization': 'Bearer $token'
    //   }, body: {
    //     "title": postTitle,
    //     "body": postBody,
    //     "image": file.readAsByte(),
    //   }).then((res) {
    //     print(res.statusCode);
    //   }).catchError((err) {
    //     print(err);
    //   });
  }

  Widget newPostDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'New Post',
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              style: TextStyle(
                color: Color.fromRGBO(125, 208, 230, 1),
              ),
              onSaved: (val) => postTitle = val,
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
              minLines: 3,
              maxLines: 4,
              style: TextStyle(
                color: Color.fromRGBO(125, 208, 230, 1),
              ),
              onSaved: (val) => postBody = val,
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
                VerticalDivider(),
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
