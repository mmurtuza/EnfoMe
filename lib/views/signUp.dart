import 'dart:convert';
import 'package:enfome/views/home.dart';
import 'package:enfome/views/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:enfome/models/reg_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:enfome/util/networkUtil.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // const _SignUpState({Key key}) : super(key: key);
  var _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int _radioValue = 0;
  bool _passVisible = true;
  bool _passVisible1 = true;
  bool _autoValidate = false;
  int typeSelector = 1;
  int distId;
  List instituteList = List();
  List distList = List();
  List subDistList = List();
  List<String> sDistList, sSubDistList, sInstituteList = List();
  Map<String, dynamic> bodyOfPost1, bodyOfPost2, bodyOfPost3, bodyOfPost;

  String inFName = null, inLName = null, inInsType = null, inSInst = null;

  String firstName,
      lastName,
      email,
      cell,
      password,
      password_confirmation,
      type,
      ins_reg_no,
      ins_name,
      dis_selection,
      uni_selection,
      stu_institute,
      tea_institute;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          type = 'institute';
          typeSelector = 1;

          break;
        case 1:
          type = 'student';
          typeSelector = 2;

          break;
        case 2:
          type = 'teacher';
          typeSelector = 3;
          break;
      }
    });
  }

  Future<String> instList() async {
    String url = NetworkUtil.allInstListUrl;
    print(url);
    final response = await http.get(url);
    print('inli ${response.statusCode}');
    if (response.statusCode == 200) {
      final String res = response.body;
      var resBody = jsonDecode(res);
      print(resBody);
      setState(() {
        instituteList = resBody['institutes'];

        List temp = instituteList.map((item) {
          print("item $item");
          return item['name'];
        }).toList();
        print("temp $temp");

        sInstituteList = List<String>.from(temp);
        print(sInstituteList);
      });

      return 'instituteListModelFromJson(res)';
    } else {
      print('err');
      return null;
    }
  }

  Future<String> districtList() async {
    final response = await http.get(NetworkUtil.distUrl);
    if (response.statusCode == 200) {
      final String res = response.body;
      var resBody = jsonDecode(res);

      print('future' + resBody['districts'].toString() + 'future');
      setState(() {
        distList = resBody['districts'];

        List temp = distList.map((item) {
          return item['bengali_name'];
          // print("item $item");
        }).toList();
        // print("temp $temp");

        sDistList = List<String>.from(temp);
        // distId = '5';
      });
      return "su";
    } else {
      print('error');
      return null;
    }
  }

  Future<String> subDistrictList() async {
    String url =
        NetworkUtil.baseUrl + '/' + distId.toString() + '/sub_districts';
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final String res = response.body;
      var resBody = jsonDecode(res);

      // print('future' + resBody['subdistricts'].toString() + 'future');
      setState(() {
        subDistList = resBody['subdistricts'];
      });
      return 'sub';
    } else {
      return null;
    }
  }

  Future<String> register(bodyOfPost) async {
    final response = await http.post(NetworkUtil.regUrl, body: bodyOfPost);

    print('vorosh ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      final String res = response.body;
      Navigator.pushReplacementNamed(
        context,
        Home.routeName,
      );
      return 'S';
    } else {
      return null;
    }
  }

  // Future<RegModel> register(
  //   firstName,
  //   lastName,
  //   email,
  //   cell,
  //   password,
  //   password_confirmation,
  //   type,
  //   ins_reg_no,
  //   ins_name,
  //   dis_selection,
  //   uni_selection,
  //   stu_institute,
  //   tea_institute,
  // ) async {
  //   final response = await http.post(NetworkUtil.regUrl, body: {
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'email': email,
  //     'cell': cell,
  //     'password': password,
  //     'password_confirmation': password_confirmation,
  //     'type': type,
  //     'ins_reg_no': ins_reg_no,
  //     'ins_name': ins_name,
  //     'dis_selection': dis_selection,
  //     'uni_selection': uni_selection,
  //     'stu_institute': stu_institute,
  //     'tea_institute': tea_institute,
  //   });

  //   print('vorosh ${response.statusCode}');
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final String res = response.body;
  //     Navigator.pushReplacementNamed(
  //       context,
  //       Home.routeName,
  //     );
  //     return regModelFromJson(res);
  //   } else {
  //     return null;
  //   }
  // }

  void _submit() async {
    bodyOfPost1 = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'cell': cell,
      'password': password,
      'password_confirmation': password_confirmation,
      'type': type,
      'ins_reg_no': ins_reg_no,
      'ins_name': ins_name,
    };
    bodyOfPost2 = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'cell': cell,
      'password': password,
      'password_confirmation': password_confirmation,
      'ins_name': ins_name,
      'dis_selection': dis_selection,
      'uni_selection': uni_selection,
      'stu_institute': stu_institute,
    };
    bodyOfPost3 = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'cell': cell,
      'password': password,
      'password_confirmation': password_confirmation,
      'tea_institute': tea_institute,
    };
    if (typeSelector == 0) {
      bodyOfPost = bodyOfPost1;
    } else if (typeSelector == 1) {
      bodyOfPost = bodyOfPost2;
    } else if (typeSelector == 2) {
      bodyOfPost = bodyOfPost3;
    } else {
      print('error!');
    }
    print(
        "$firstName $lastName,$email,$cell,$password,$password_confirmation,$type, $ins_reg_no,$ins_name,$dis_selection,$uni_selection,$stu_institute,$tea_institute");
    register(bodyOfPost);
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      print(
          "$firstName $lastName,$email,$cell,$password,$password_confirmation,$type, $ins_reg_no,$ins_name,$dis_selection,$uni_selection,$stu_institute,$tea_institute");
    } else {
//    If all data are not valid then start auto validation.
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  String validateName(String value) {
    if (value.length < 5)
      return 'Name must be more than 6 charater';
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length != 11)
      return 'Mobile Number must be of 11 digit';
    else
      return null;
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

  String validatePass(String value) {
    if (value != password) {
      return 'Password don\'t match';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    this.districtList();
    // this.subDistrictList();
    this.instList();
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
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _fNameField(),
                _lNameField(),
                _emailField(),
                _pnNoField(),
                _passWordField(),
                _rePassWordField(),
                SizedBox(
                  height: 10,
                ),
                _accType(),
                _insttuteRegNo(),
                _insttuteRegNname(),
                _insttuteRegType(),
                _district(),
                _union(),
                _studentInst(),
                _teacherInst(),
                _signUpBtn(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _fNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
      child: TextFormField(
        initialValue: inFName,
        onChanged: (value) => inFName = value,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        // validator: validateName,
        onSaved: (value) => firstName = value,
        decoration: InputDecoration(
          hintText: 'Enter First Name',
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
      ),
    );
  }

  Widget _lNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: TextFormField(
        initialValue: inLName,
        onChanged: (value) => inLName = value,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        // validator: validateName,
        onSaved: (val) => lastName = val,
        decoration: InputDecoration(
          hintText: 'Enter Last Name',
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        validator: validateEmail,
        onSaved: (val) => email = val,
        decoration: InputDecoration(
          hintText: 'Enter Your E-mail',
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
      ),
    );
  }

  Widget _pnNoField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        onSaved: (val) => cell = val,
        validator: validateMobile,
        controller: _controller,
        // onChanged: validateMobile,
        decoration: InputDecoration(
          hintText: 'Enter Your Mobile Number',
          // prefixText: '+880',
          // prefixStyle: TextStyle(
          //   color: Color.fromRGBO(125, 208, 230, 1),
          // ),
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
      ),
    );
  }

  Widget _passWordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: TextFormField(
        controller: _controller,
        obscureText: _passVisible,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        onSaved: (val) => password = val,
        decoration: InputDecoration(
          hintText: 'Enter A New Password',
          suffixIcon: IconButton(
            icon: Icon(
              _passVisible ? Icons.visibility : Icons.visibility_off,
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            onPressed: () {
              setState(() {
                _passVisible = !_passVisible;
              });
            },
          ),
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
      ),
    );
  }

  Widget _rePassWordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: TextFormField(
        controller: _controller,
        obscureText: _passVisible1,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        //validator: validatePass,
        decoration: InputDecoration(
          hintText: 'Enter The Password Again',
          suffixIcon: IconButton(
            icon: Icon(
              _passVisible1 ? Icons.visibility : Icons.visibility_off,
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            onPressed: () {
              setState(() {
                _passVisible1 = !_passVisible1;
              });
            },
          ),
          hintStyle: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          border: _bord(),
          enabledBorder: _bord(),
          focusedBorder: _bord(),
        ),
        onSaved: (val) {
          password_confirmation = val;
        },
      ),
    );
  }

  Widget _insttuteRegNo() {
    if (typeSelector == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: TextFormField(
          controller: _controller,
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (value) => ins_reg_no = value,
          decoration: InputDecoration(
            hintText: 'Institute Registration Number',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _insttuteRegNname() {
    if (typeSelector == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: TextFormField(
          controller: _controller,
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (value) => ins_name = value,
          decoration: InputDecoration(
            hintText: 'Institute Name',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _insttuteRegType() {
    if (typeSelector == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (val) => type = val,
          decoration: InputDecoration(
            hintText: 'Institute Type',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
          onChanged: (String value) {},
          items: ["School", "Collage", "School"]
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _district() {
    if (typeSelector == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (val) => dis_selection = val,
          decoration: InputDecoration(
            hintText: 'Select District',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
          onChanged: (val) {
            setState(() {
              dis_selection = val;
              distId = int.parse(val);
              subDistrictList();
            });
          },
          items: distList
              .map((label) => DropdownMenuItem(
                    child: Text(label['bengali_name']),
                    value: label['id'].toString(),
                  ))
              .toList(),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _union() {
    if (typeSelector == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (val) => uni_selection = val,
          decoration: InputDecoration(
            hintText: 'Select Union',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
          onChanged: (String value) {
            uni_selection = value;
          },
          items: subDistList
              .map((label) => DropdownMenuItem(
                    child: Text(label['bengali_name']),
                    value: label['id'].toString(),
                  ))
              .toList(),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _teacherInst() {
    if (typeSelector == 3) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (val) => tea_institute = val,
          decoration: InputDecoration(
            hintText: 'Select Institute',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
          onChanged: (String value) {},
          items: sInstituteList
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _studentInst() {
    if (typeSelector == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          style: TextStyle(
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
          // validator: validateName,
          onSaved: (val) => stu_institute = val,
          decoration: InputDecoration(
            hintText: 'Select Institute',
            hintStyle: TextStyle(
              color: Color.fromRGBO(125, 208, 230, 1),
            ),
            border: _bord(),
            enabledBorder: _bord(),
            focusedBorder: _bord(),
          ),
          onChanged: (String value) {},
          items: instituteList
              .map((label) => DropdownMenuItem(
                    child: Text(label['name']),
                    value: label['id'].toString(),
                  ))
              .toList(),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _accType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: 0,
          activeColor: Color.fromRGBO(125, 208, 230, 1),
          groupValue: _radioValue,
          onChanged: (val) {
            print("Radio $val");
            _handleRadioValueChange(val);
          },
        ),
        Text(
          'Institute',
          style: TextStyle(
            fontSize: 16.0,
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
        ),
        Radio(
          value: 1,
          activeColor: Color.fromRGBO(125, 208, 230, 1),
          groupValue: _radioValue,
          onChanged: (val) {
            print("Radio $val");
            _handleRadioValueChange(val);
          },
        ),
        Text(
          'Student/Staff',
          style: TextStyle(
            fontSize: 16.0,
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
        ),
        Radio(
          value: 2,
          activeColor: Color.fromRGBO(125, 208, 230, 1),
          groupValue: _radioValue,
          onChanged: (val) {
            print("Radio $val");
            _handleRadioValueChange(val);
          },
        ),
        Text(
          'Teacher',
          style: TextStyle(
            fontSize: 16.0,
            color: Color.fromRGBO(125, 208, 230, 1),
          ),
        ),
      ],
    );
  }

  Widget _signUpBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: OutlineButton(
        disabledTextColor: Color.fromRGBO(125, 208, 230, 1),
        highlightedBorderColor: Color.fromRGBO(125, 208, 230, 1),
        borderSide: BorderSide(
          width: 2,
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        padding: EdgeInsets.all(10),
        splashColor: Color.fromRGBO(125, 208, 230, 0.3),
        onPressed: _submit,
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return BottomAppBar(
      child: Container(
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
                child: Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _bord() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Color.fromRGBO(125, 208, 230, 1),
        width: 2,
      ),
    );
  }
}
