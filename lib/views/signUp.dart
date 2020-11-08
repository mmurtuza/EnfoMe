import 'dart:convert';
import 'package:dio/dio.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enfome/util/constants.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // const _SignUpState({Key key}) : super(key: key);
  var _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
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
  String msg = null;
  bool hasMsg;

  String inFName = null,
      inLName = null,
      inemail = null,
      inphone = null,
      inpass = null,
      inrepass = null,
      inregno = null,
      ininstname = null,
      ininsttype = null,
      indist = null,
      inuni = null,
      insins = null,
      intins = null,
      instype = null;

  String firstName,
      lastName,
      email,
      cell,
      password,
      password_confirmation,
      type = 'institute',
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
          setState(() {
            type = 'institute';
          });

          typeSelector = 1;

          break;
        case 1:
          setState(() {
            type = 'student';
          });
          typeSelector = 2;

          break;
        case 2:
          setState(() {
            type = 'teacher';
          });
          typeSelector = 3;
          break;
      }
    });
  }

  Future<String> instList() async {
    String url = NetworkUtil.allInstListUrl;
    // print(url);
    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
      print('inli ${response.statusCode}');
      if (response.statusCode == 200) {
        final String res = response.body;
        var resBody = jsonDecode(res);
        print(resBody);
        setState(() {
          instituteList = resBody['institutes'];

          // List temp = instituteList.map((item) {
          //   print("item $item");
          //   return item['name'];
          // }).toList();
          // print("temp $temp");

          // sInstituteList = List<String>.from(temp);
          // print(sInstituteList);
        });

        return 'instituteListModelFromJson(res)';
      } else {
        print('err');
        return '';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> districtList() async {
    try {
      final response = await http
          .get(NetworkUtil.distUrl, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final String res = response.body;
        var resBody = jsonDecode(res);

        // print('future' + resBody['districts'].toString() + 'future');
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
    } catch (e) {
      print(e);
    }
  }

  Future<String> subDistrictList() async {
    String url =
        NetworkUtil.baseUrl + '/' + distId.toString() + '/sub_districts';
    try {
      final response =
          await http.get(url, headers: {'Accept': 'application/json'});
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
    } catch (e) {
      print(e);
    }
  }

  Future<String> register(bodyOfPost) async {
    print(bodyOfPost);
    final form = _formKey.currentState;
    try {
      if (form.validate()) {
        setState(() => _isLoading = true);
        form.save();
        final response2 = await http.post(NetworkUtil.regUrl,
            body: bodyOfPost, headers: {'Accept': 'application/json'});

        print(' ${response2.statusCode}');
        print(' body ${response2.body} body');
        // var res = jsonDecode(response.body);
        if (response2.statusCode == 200) {
          print('1');
          final res2 = response2.body;
          print('$res2');
          var resBody = jsonDecode(res2);
          print('2');

          if (resBody == false) {
            msg = 'msg'; //resBody['message'] + '!';
            setState(() {
              hasMsg = true;
            });
          }
          print(resBody['access_token']);
          print('3');
          if (resBody['status'] == true) {
            final storage = new FlutterSecureStorage();
            print('4');
            await storage.delete(key: 'token');
            await storage.write(
                key: 'token', value: resBody['access_token'].toString());
            print('5');
            Constrants.pref.setBool('login', true);
            print('6');
            // final String res = response.body;
            Navigator.pushReplacementNamed(
              context,
              Home.routeName,
            );
          }
          setState(() => _isLoading = false);
          return '200';
        } else if (response2.statusCode == 404) {
          setState(() {
            msg = 'Check your internet connection!';
            _isLoading = false;
          });
          return '404';
        } else if (response2.statusCode == 500) {
          setState(() {
            msg = 'Server error try again after some time!';
            _isLoading = false;
          });
          return '500';
        } else {
          setState(() => _isLoading = false);
          return 'nn';
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print(e);
    }
  }

  void _submit() async {
    setState(() => _isLoading = true);
    // one of the veriable will be pasd to the post methode
    bodyOfPost1 = {
      'firstName': inFName,
      'lastName': inLName,
      'email': inemail,
      'cell': inphone,
      'password': inpass,
      // 'password_confirmation': inrepass,
      'type': type,
      'ins_reg_no': inregno,
      'ins_name': ininstname,
      'dis_selection': indist,
      'uni_selection': inuni,
      'ins_type': ininsttype,
    };
    bodyOfPost2 = {
      'firstName': inFName,
      'lastName': inLName,
      'email': inemail,
      'cell': inphone,
      'password': inpass,
      // 'password_confirmation': inrepass,
      'stu_institute': insins,
      'type': type,
    };
    bodyOfPost3 = {
      'firstName': inFName,
      'lastName': inLName,
      'email': inemail,
      'cell': inphone,
      'password': inpass,
      // 'password_confirmation': inrepass,
      'tea_institute': intins,
      'type': type,
    };
    //condition check
    if (typeSelector == 1) {
      bodyOfPost = bodyOfPost1;
    } else if (typeSelector == 2) {
      bodyOfPost = bodyOfPost2;
    } else if (typeSelector == 3) {
      bodyOfPost = bodyOfPost3;
    } else {
      print('error!');
    }
    print("$bodyOfPost"); //For debuggin
    //Methode call
    register(bodyOfPost);
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      // print("$firstName $lastName,$email,$cell,$password,$password_confirmation,$type, $ins_reg_no,$ins_name,$dis_selection,$uni_selection,$stu_institute,$tea_institute");
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
    if (value.length < 1)
      return 'Name cannot be empty';
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
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length < 8) {
      return 'Password must have 8 character.';
    } else if (!regExp.hasMatch(value)) {
      return 'Your password must have to contain at least an upper case, a lowercase, 1 number, and a special character!';
    } else {
      return null;
    }
  }

  String validateConPass(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    } else if (value != inpass) {
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
        title: Image.asset('assets/images/Logo.png', fit: BoxFit.scaleDown),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 450.0,
            minHeight: 700.0,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                msg == null
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
                      ),
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
                _isLoading
                    ? AlertDialog(
                        content: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
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
        validator: validateName,
        onSaved: (value) => inFName = value,
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
        validator: validateName,
        onSaved: (val) => inLName = val,
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
        initialValue: inemail,
        onChanged: (value) {
          inemail = value;
        },
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
        initialValue: inphone,
        onChanged: (val) {
          inphone = val;
        },
        keyboardType: TextInputType.phone,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        onSaved: (val) => cell = val,
        validator: validateMobile,
        // controller: _controller,
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
        validator: validatePass,
        initialValue: inpass,
        onChanged: (value) {
          inpass = value;
        },
        // controller: _controller,
        obscureText: _passVisible,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        onSaved: (val) => inpass = val,
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
        initialValue: inrepass,
        onChanged: (value) {
          inrepass = value;
        },
        // controller: _controller,
        obscureText: _passVisible1,
        style: TextStyle(
          color: Color.fromRGBO(125, 208, 230, 1),
        ),
        validator: validateConPass,
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
          initialValue: inregno,
          onChanged: (val) {
            inregno = val;
          },
          // controller: _controller,
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
          initialValue: ininstname,
          onChanged: (value) {
            ininstname = value;
          },
          // controller: _controller,
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
          value: ininsttype,
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
          onChanged: (String value) {
            ininsttype = value;
          },
          items: ["School", "College", "University"]
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
    if (typeSelector == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          value: indist,
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
            indist = val;
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
    if (typeSelector == 1) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          value: inuni,
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
          items: subDistList
              .map((label) => DropdownMenuItem(
                    child: Text(label['bengali_name']),
                    value: label['id'].toString(),
                  ))
              .toList(),

          onChanged: (String value) {
            inuni = value;
            uni_selection = value;
          },
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
          value: intins,
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
          onChanged: (String value) {
            intins = value;
          },
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

  Widget _studentInst() {
    if (typeSelector == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
        child: DropdownButtonFormField(
          value: insins,
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
          onChanged: (String value) {
            insins = value;
          },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: 0,
              activeColor: Color.fromRGBO(125, 208, 230, 1),
              groupValue: _radioValue,
              onChanged: (val) {
                // print("Radio $val");
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
          ],
        ),
        Row(
          children: [
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
              'Student',
              style: TextStyle(
                fontSize: 16.0,
                color: Color.fromRGBO(125, 208, 230, 1),
              ),
            ),
          ],
        ),
        Row(
          children: [
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
