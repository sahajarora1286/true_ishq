import 'package:true_ishq/screens/login_phone.dart';
import 'package:true_ishq/utilities/helpers.dart';
import 'package:flutter/material.dart';
import "../services/api/user-api.service.dart" as apiService;

class LoginOptionsController extends StatefulWidget {
  LoginOptionsController({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginOptionsControllerState createState() => _LoginOptionsControllerState();
}

class _LoginOptionsControllerState extends State<LoginOptionsController> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  _fetchUsers() async {
    await apiService.getUsers().then((dynamic result) {
      printWrapped('result from getData: ' + result.toString());
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
        child: new RaisedButton(
          child: new Text("Log in with Phone Number"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPhoneController(
                  title: "Phone Number",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
