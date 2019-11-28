import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  String name, user, password;
  final formKey = GlobalKey<FormState>();

  // Method

  Widget nameForm() {
    Color color = Colors.brown;
    return TextFormField(
      onSaved: (String string) {
        name = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        icon: Icon(
          Icons.account_box,
          size: 36.0,
          color: color,
        ),
        labelText: 'Name :',
        labelStyle: TextStyle(color: color),
        helperText: 'Type Your Name in the Blank',
        helperStyle: TextStyle(color: color),
        hintText: 'English Only',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }

  Widget userForm() {
    Color color = Colors.green.shade800;
    return TextFormField(
      onSaved: (String string) {
        user = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: color,
        ),
        labelText: 'User :',
        labelStyle: TextStyle(color: color),
        helperText: 'Type Your User in the Blank',
        helperStyle: TextStyle(color: color),
        hintText: 'English Only',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }

  Widget passwordForm() {
    Color color = Colors.purple;
    return TextFormField(
      onSaved: (String string) {
        password = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: color,
        ),
        labelText: 'Password :',
        labelStyle: TextStyle(color: color),
        helperText: 'Type Your Password in the Blank',
        helperStyle: TextStyle(color: color),
        hintText: 'English Only',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
    );
  }

  Widget registerButton() {
    return IconButton(
      tooltip: 'Upload To Server',
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        formKey.currentState.save();
        print('name = $name, user = $user, password = $password');
        if (name.isEmpty || user.isEmpty || password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread()async{

    String url = 'https://www.androidthai.in.th/jon/addUserMaster.php?isAdd=true&Name=$name&User=$user&Password=$password';

    Response response = await get(url);
    var result = json.decode(response.body);
    if (result.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalDialog(context, 'Register False', 'Please Try Agains');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().textColor,
        title: Text('Register'),
      ),
      body: Form(key: formKey,
        child: ListView(
          padding: EdgeInsets.all(40.0),
          children: <Widget>[
            nameForm(),
            userForm(),
            passwordForm(),
          ],
        ),
      ),
    );
  }
}
