import 'package:true_ishq/components/custom_text_form_field.dart';
import 'package:true_ishq/models/user.dart';
import 'package:true_ishq/screens/swiper.dart';
import 'package:true_ishq/utilities/helpers.dart';
import 'package:flutter/material.dart';
import "../services/api/user-api.service.dart" as apiService;

class LoginPasswordController extends StatefulWidget {
  LoginPasswordController({Key key, this.title, this.user}) : super(key: key);

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
  _LoginPasswordControllerState createState() =>
      _LoginPasswordControllerState();
}

class _LoginPasswordControllerState extends State<LoginPasswordController> {
  final _formKey = GlobalKey<FormState>();
  User user = new User();

  @override
  void initState() {
    super.initState();
    this.user = widget.user;
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: CustomTextFormFieldWidget(
                  icon: Icon(Icons.lock),
                  hintText: "password",
                  type: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => this.user.password = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await apiService.login(this.user).then(
                        (dynamic result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SwiperController(
                                title: "True Ishq",
                              ),
                            ),
                          );
                        },
                      ).catchError((error) {
                        printWrapped(error.toString());
                      });
                    }
                  },
                  child: Text('Login'),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
