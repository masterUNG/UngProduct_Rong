import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungproduct/scaffold/my_service.dart';
import 'package:ungproduct/scaffold/register.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/utility/normal_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Field
  bool status = false;
  String user, password;
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> userMap = Map();

  // Method
  @override
  void initState() {
    super.initState();
    readSharePreferance();
  }

  Future<void> readSharePreferance() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      bool remember = sharedPreferences.getBool('Remember');
      print('remember = $remember');

      if (remember) {
        userMap['id'] = sharedPreferences.getString('id');
        userMap['Name'] = sharedPreferences.getString('Name');
        userMap['User'] = sharedPreferences.getString('User');
        userMap['Password'] = sharedPreferences.getString('Password');

        routeToMyService();
      }
    } catch (e) {}
  }

  Widget signInButton() {
    return Expanded(
      flex: 1,
      child: RaisedButton(
        color: MyStyle().textColor,
        child: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          formKey.currentState.save();
          print('user = $user, password = $password');

          if (user.isEmpty || password.isEmpty) {
            normalDialog(context, 'Have Space', 'Please Fill All Every Blank');
          } else {
            authenThread();
          }
        },
      ),
    );
  }

  Future<void> authenThread() async {
    String url =
        'https://www.androidthai.in.th/jon/getUserWhereUserMaster.php?isAdd=true&User=$user';

    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');

    if (result.toString() == 'null') {
      normalDialog(context, 'User False', 'No $user in my Database');
    } else {
      for (var map in result) {
        userMap = map;

        if (password == userMap['Password']) {
          if (status) {
            saveSharePreferance();
          }

          routeToMyService();
        } else {
          normalDialog(
              context, 'Password False', "Please Try Again Password False");
        }
      }
    }
  }

  Future<void> saveSharePreferance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('id', userMap['id']);
    sharedPreferences.setString('Name', userMap['Name']);
    sharedPreferences.setString('User', userMap['User']);
    sharedPreferences.setString('Password', userMap['Password']);
    sharedPreferences.setBool('Remember', true);
  }

  void routeToMyService() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService(
        map: userMap,
      );
    });
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Widget signUpButton() {
    return Expanded(
      flex: 1,
      child: OutlineButton(
        borderSide: BorderSide(color: MyStyle().textColor),
        child: Text(
          'Sign Up',
          style: TextStyle(color: MyStyle().textColor),
        ),
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return Register();
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget showButton() {
    return Container(
      // color: Colors.grey,
      width: 250.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          signInButton(),
          SizedBox(
            width: 5.0,
          ),
          signUpButton(),
        ],
      ),
    );
  }

  Widget rememberCheckBox() {
    return Container(
      width: 250.0,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          'Remember Me',
          style: TextStyle(color: MyStyle().textColor),
        ),
        value: status,
        onChanged: (bool value) {
          onRememberChange(value);
        },
      ),
    );
  }

  void onRememberChange(bool value) {
    setState(() {
      status = value;
    });
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextFormField(
        onSaved: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
            labelText: 'User :',
            labelStyle: TextStyle(color: MyStyle().textColor)),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextFormField(
        onSaved: (String string) {
          password = string.trim();
        },
        decoration: InputDecoration(
            labelText: 'Password :',
            labelStyle: TextStyle(color: MyStyle().textColor)),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Ung Product',
      style: TextStyle(
        fontSize: MyStyle().h1,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: MyStyle().textColor,
        fontFamily: MyStyle().font,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/wall.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30.0),
                decoration:
                    BoxDecoration(color: Color.fromARGB(150, 255, 255, 255)),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      showLogo(),
                      showAppName(),
                      userForm(),
                      passwordForm(),
                      rememberCheckBox(),
                      showButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
