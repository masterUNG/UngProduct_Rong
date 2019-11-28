import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungproduct/scaffold/add_product.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/widget/show_list_product.dart';

class MyService extends StatefulWidget {
  final Map<String, dynamic> map;
  MyService({Key key, this.map}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String login = '...';
  Map<String, dynamic> currentMap = Map();
  Widget currentWidget = ShowListProduct();

  // Method
  @override
  void initState() {
    super.initState();
    currentMap = widget.map;
    login = currentMap['Name'];
  }

  Widget menuShowListProduct() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
      ),
      title: Text('List Product'),
      subtitle: Text('List All Product in ListView'),
      onTap: () {
        currentWidget = ShowListProduct();
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuAddProduct() {
    return ListTile(
      leading: Icon(
        Icons.add_a_photo,
        size: 36.0,
      ),
      title: Text('Add Product'),
      subtitle: Text('Add Product in ListView'),
      onTap: () {

        Navigator.of(context).pop();

        MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context){return AddProduct();});
        Navigator.of(context).push(materialPageRoute);

        
      },
    );
  }

  Widget menuReadQRcode() {
    return ListTile(
      leading: Icon(
        Icons.photo_camera,
        size: 36.0,
      ),
      title: Text('Read QR or Bar Code'),
      subtitle: Text('Process Read QR code and Bar Code'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuSearchProduct() {
    return ListTile(
      leading: Icon(
        Icons.search,
        size: 36.0,
      ),
      title: Text('Search Product'),
      subtitle: Text('Search All Product in SearchView'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget showLogin() {
    return Text('Login by $login');
  }

  Widget showAppName() {
    return Text('Ung Product');
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget menuLogOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
      ),
      title: Text('Log Out & Exit'),
      subtitle: Text('Descrip of Log Out and Exit'),
      onTap: () {
        Navigator.of(context).pop();
        clearSharePreferance();
      },
    );
  }

  Future<void> clearSharePreferance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear().then((object) {
      exit(0);
    });
  }

  Widget headDrawer() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, MyStyle().mainColor],
          radius: 0.8,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          menuShowListProduct(),
          menuAddProduct(),
          menuReadQRcode(),
          menuSearchProduct(),
          menuLogOut(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().textColor,
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
