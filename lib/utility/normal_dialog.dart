import 'package:flutter/material.dart';
import 'package:ungproduct/utility/my_style.dart';

Widget showTitle(String title) {
  return ListTile(
    leading: Icon(
      Icons.add_alert,
      color: Colors.red,
      size: 36.0,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.red,
        fontSize: MyStyle().h2,
      ),
    ),
  );
}

Widget okButton(BuildContext buildContext) {
  return FlatButton(
    child: Text('OK'),
    onPressed: () {
      Navigator.of(buildContext).pop();
    },
  );
}

Future<void> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: showTitle(title),
        content: Text(message),
        actions: <Widget>[okButton(buildContext)],
      );
    },
  );
}
