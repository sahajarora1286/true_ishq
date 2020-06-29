import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:true_ishq/components/custom_text_form_field.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:true_ishq/services/auth.service.dart';
import "../services/api/user-api.service.dart" as apiService;
import '../utilities/helpers.dart';

class EditProfileController extends StatefulWidget {
  EditProfileController({Key key, this.title, this.user}) : super(key: key);

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
  _EditProfileControllerState createState() => _EditProfileControllerState();
}

class _EditProfileControllerState extends State<EditProfileController> {
  final _formKey = GlobalKey<FormState>();
  User user = new User();
  File imageFile;
  bool _isLoading;
  var authService;

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

  void submitClicked(BuildContext context) async {

    // if (!_formKey.currentState.validate()) {
    //   return;
    // }
    _formKey.currentState.save();

    print('uploading');
    setState(() {
      _isLoading = true;
    });

    await apiService.setProfilePicture(this.user, this.imageFile).then(
      (result) async {
        

        // user = result;

        await apiService.updateUserProfile(this.user);

        // await authService.loginUser(user);

        setState(() {
          _isLoading = false;
        });

        // Navigator.popUntil(
        //     context, ModalRoute.withName(Navigator.defaultRouteName));
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          authService.currentUser.profile.firstName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              new Center(
                child: _getPictureWidget(),
              ),
              _getSectionHeader("BIO"),
              _getBioTf(),
              _getOccupationTf(),
              _getAgeTf(),
              _getSectionHeader("APPEARANCE"),
              Listener(
                child: _getHeightTf(),
                onPointerDown: (event) {
                  print('tapped');
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black54,
                    builder: (BuildContext builder) {
                      return Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            right: 10,
                            child: FlatButton(
                              child: Text(
                                'Done',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              textColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: _getHeightPicker(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              _getSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSectionHeader(String headerText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Text(
        headerText,
        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _getBioTf() {
    return CustomTextFormFieldWidget(
      hintText: "Describe yourself in a few words",
      maxLines: null,
      obscureText: false,
      icon: Icon(Icons.person),
      validator: (value) {
        // _formKey.currentState.save();
        // if (value.isEmpty) {
        //   return 'Please confirm your password';
        // }
        // if (value != this.user.password) {
        //   return 'Passwords must match';
        // }
        // return null;
      },
      onSaved: (val) {
         setState(() => this.user.profile.description = val);
      },
    );
  }

  Widget _getOccupationTf() {
    return CustomTextFormFieldWidget(
      hintText: "What do you do?",
      obscureText: false,
      icon: Icon(Icons.work),
      validator: (value) {
        // _formKey.currentState.save();
        // if (value.isEmpty) {
        //   return 'Please confirm your password';
        // }
        // if (value != this.user.password) {
        //   return 'Passwords must match';
        // }
        // return null;
      },
      onSaved: (val) {
        setState(() => this.user.profile.occupation = val);
      },
    );
  }

  Widget _getAgeTf() {
    return CustomTextFormFieldWidget(
      hintText: "How old are you?",
      icon: Icon(Icons.cake),
      type: TextInputType.number,
      validator: (value) {
        // _formKey.currentState.save();
        // if (value.isEmpty) {
        //   return 'Please confirm your password';
        // }
        // if (value != this.user.password) {
        //   return 'Passwords must match';
        // }
        // return null;
      },
      onSaved: (val) {
        setState(() => this.user.profile.age = int.parse(val));
      },
    );
  }

  Widget _getHeightTf() {
    return CustomTextFormFieldWidget(
      hintText: "How tall are you?",
      icon: Icon(Icons.accessibility),
      type: TextInputType.number,
      readonly: true,
      validator: (value) {
        // _formKey.currentState.save();
        // if (value.isEmpty) {
        //   return 'Please confirm your password';
        // }
        // if (value != this.user.password) {
        //   return 'Passwords must match';
        // }
        // return null;
      },
      onSaved: (val) {
        setState(() => this.user.profile.height = double.parse(val));
      },
    );
  }

  Widget _getHeightPicker() {
    return Stack(
      children: <Widget>[
        // Positioned(
        //   top: 0,
        //   right: 10,
        //   child: FlatButton(
        //     // elevation: 5,
        //     child: Text(
        //       'Done',
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //     onPressed: () {},
        //     textColor: Theme.of(context).primaryColor,
        //   ),
        // ),
        Container(
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 50,
                  onSelectedItemChanged: (int index) {},
                  children: List<Widget>.generate(
                    8,
                    (int index) {
                      return new Text(
                        '${index + 1} ft',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  itemExtent: 50,
                  onSelectedItemChanged: (int index) {},
                  children: List<Widget>.generate(
                    12,
                    (int index) {
                      return new Text(
                        '${index + 1} inches',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _getSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: _isLoading == true
          ? _showCircularProgress()
          : RaisedButton(
              onPressed: () async {
                if (imageFile != null) {
                  submitClicked(context);
                }
              },
              child: Text('Get Started'),
            ),
    );
  }

  Widget _getPictureWidget() {
    return new GestureDetector(
      onTap: getImage,
      child: new Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white),
          height: 150,
          width: 150,
          child: imageFile != null
              ? Image.file(imageFile)
              : Icon(Icons.add_a_photo),
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
}
