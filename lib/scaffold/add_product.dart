import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungproduct/utility/my_style.dart';
import 'package:ungproduct/utility/normal_dialog.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Field
  File file;
  String name, detail, nameImage, nameCode;
  final formKey = GlobalKey<FormState>();

  // Method
  Widget uploadData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          // padding: EdgeInsets.only(left: 40.0, right: 40.0),
          width: MediaQuery.of(context).size.width,
          // color: Colors.grey,
          child: RaisedButton(
            color: MyStyle().textColor,
            child: Text(
              'Upload Data',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              formKey.currentState.save();
              if (name.isEmpty || detail.isEmpty) {
                normalDialog(context, 'Have Space', 'Please Fill Every Blank');
              }
              if (file == null) {
                normalDialog(
                    context, 'Not Choose Image', 'Please Choose Image');
              } else {
                uploadImageToServer();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> uploadImageToServer() async {
    String urlServer = 'https://www.androidthai.in.th/jon/saveFileUng.php';

    Random random = Random();
    int myInt = random.nextInt(10000);
    nameImage = 'image$myInt.jpg';
    nameCode = 'code$myInt';

    try {
      FormData formData =
          FormData.from({'file': UploadFileInfo(file, nameImage)});
      await Dio().post(urlServer, data: formData).then((response) {
        print('Success Upload');
        uploadMySQL();
      });
    } catch (e) {}
  }

  Future<void> uploadMySQL()async{

    String path = 'https://www.androidthai.in.th/jon/UploadUng/$nameImage';
    String url = 'https://www.androidthai.in.th/jon/addProductMaster.php?isAdd=true&Name=$name&Detail=$detail&Path=$path&Code=$nameCode';

    var response = await get(url);
    var result = json.decode(response.body);

    if (result.toString() == 'true') {
      Navigator.of(context).pop();
    } else {
      normalDialog(context, 'Cannot Upload', 'Please Try Ageins');
    }


  }

  Widget nameForm() {
    return Container(
      margin: EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextFormField(
        onSaved: (String string) {
          name = string.trim();
        },
        decoration: InputDecoration(labelText: 'Name :'),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      margin: EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextFormField(
        onSaved: (String string) {
          detail = string.trim();
        },
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(labelText: 'detail :'),
      ),
    );
  }

  Widget cameraButton() {
    return RaisedButton.icon(
      color: MyStyle().textColor,
      icon: Icon(
        Icons.add_a_photo,
        color: Colors.white,
      ),
      label: Text(
        'Camera',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        cameraThread();
      },
    );
  }

  Future<void> cameraThread() async {
    var object = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 800.0, maxHeight: 480.0);

    setState(() {
      file = object;
    });
  }

  Widget galleryButton() {
    return RaisedButton.icon(
      color: MyStyle().mainColor,
      icon: Icon(Icons.photo),
      label: Text('Gallery'),
      onPressed: () {
        galleryThread();
      },
    );
  }

  Future<void> galleryThread() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 800.0, maxHeight: 480.0);
    setState(() {
      file = image;
    });
  }

  Widget showButton() {
    return Container(
      margin: EdgeInsets.only(left: 40.0, right: 40.0),
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          cameraButton(),
          galleryButton(),
        ],
      ),
    );
  }

  Widget showImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          height: MediaQuery.of(context).size.height * 0.3,
          child:
              file == null ? Image.asset('images/pic.png') : Image.file(file),
        ),
      ],
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            showImage(),
            showButton(),
            nameForm(),
            detailForm(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().textColor,
        title: Text('Add Product'),
      ),
      body: Stack(
        children: <Widget>[
          showContent(),
          uploadData(),
        ],
      ),
    );
  }
}
