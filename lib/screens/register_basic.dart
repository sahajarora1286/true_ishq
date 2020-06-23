import 'package:provider/provider.dart';
import 'package:true_ishq/components/custom_text_form_field.dart';
import 'package:true_ishq/models/profile.dart';
import 'package:true_ishq/models/user.dart';
import 'package:true_ishq/screens/register_picture.dart';
import 'package:true_ishq/screens/swiper.dart';
import 'package:flutter/material.dart';
import 'package:true_ishq/services/auth.service.dart';
import "../services/api/user-api.service.dart" as apiService;

class RegisterBasicController extends StatefulWidget {
  RegisterBasicController({Key key, this.title, this.user}) : super(key: key);

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
  _RegisterBasicControllerState createState() =>
      _RegisterBasicControllerState();
}

class _RegisterBasicControllerState extends State<RegisterBasicController> {
  final _formKey = GlobalKey<FormState>();
  User user = new User(profile: new Profile());
  bool _isLoading;
  var authService;

  @override
  void initState() {
    super.initState();
    this.user = widget.user;
    this.user.profile = new Profile();
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: CustomTextFormFieldWidget(
                  icon: Icon(Icons.person),
                  hintText: "Name",
                  type: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (val) =>
                      setState(() => user.profile.firstName = val),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(10.0),
              //   child: CustomTextFormFieldWidget(
              //     icon: Icon(Icons.person),
              //     hintText: "Occupation",
              //     type: TextInputType.text,
              //     validator: (value) {
              //       return null;
              //     },
              //     onSaved: (val) =>
              //         setState(() => this.user.profile.occupation = val),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: CustomTextFormFieldWidget(
                  icon: Icon(Icons.email),
                  hintText: "Email address",
                  type: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => this.user.email = val),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: CustomTextFormFieldWidget(
                  icon: Icon(Icons.lock),
                  hintText: "Password",
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
              Container(
                padding: EdgeInsets.all(10.0),
                child: CustomTextFormFieldWidget(
                  icon: Icon(Icons.lock),
                  hintText: "Confirm password",
                  type: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    _formKey.currentState.save();
                    if (value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != this.user.password) {
                      return 'Passwords must match';
                    }
                    return null;
                  },
                  onSaved: (val) =>
                      setState(() => this.user.confirmPassword = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _isLoading == true
                    ? _showCircularProgress()
                    : RaisedButton(
                        onPressed: () async {
                          _continuePressed();
                        },
                        child: Text('Continue'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _continuePressed() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });
    apiService.createUser(user).then(
      (result) async {
        setState(() {
          _isLoading = false;
        });
        user = result;
        await authService.loginUser(user);
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
