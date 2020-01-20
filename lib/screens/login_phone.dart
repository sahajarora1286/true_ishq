import 'package:true_ishq/components/custom_text_form_field.dart';
import 'package:true_ishq/models/user.dart';
import 'package:true_ishq/screens/login_password.dart';
import 'package:true_ishq/screens/register_basic.dart';
import 'package:true_ishq/utilities/helpers.dart';
import 'package:flutter/material.dart';
import "../services/api/user-api.service.dart" as apiService;

class LoginPhoneController extends StatefulWidget {
  LoginPhoneController({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPhoneControllerState createState() => _LoginPhoneControllerState();
}

class _LoginPhoneControllerState extends State<LoginPhoneController> {
  final _formKey = GlobalKey<FormState>();
  User user = new User();

  @override
  void initState() {
    super.initState();
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
                  icon: Icon(Icons.phone),
                  hintText: "phone number",
                  type: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => this.user.phone = val),
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

                      await apiService.getUserByPhone(this.user).then(
                        (result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPasswordController(
                                title: "Login",
                                user: this.user,
                              ),
                            ),
                          );
                        },
                      ).catchError((error) {
                        printWrapped(error.toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterBasicController(
                              title: "Profile",
                              user: this.user,
                            ),
                          ),
                        );
                      });
                    }
                  },
                  child: Text('Continue'),
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
