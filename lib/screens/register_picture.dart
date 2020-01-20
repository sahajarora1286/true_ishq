import 'dart:io';

import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "../services/api/user-api.service.dart" as apiService;

class RegisterPictureController extends StatefulWidget {
  RegisterPictureController({Key key, this.title, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final User user;

  @override
  _RegisterPictureControllerState createState() =>
      _RegisterPictureControllerState();
}

class _RegisterPictureControllerState extends State<RegisterPictureController> {
  User user = new User();
  File imageFile;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: new Center(
          child: new GestureDetector(
        onTap: getImage,
        child: new Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                height: 150,
                width: 150,
                child: imageFile != null
                    ? Image.file(imageFile)
                    : Icon(Icons.add_a_photo),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
