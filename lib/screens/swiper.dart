import 'dart:convert';

import 'package:true_ishq/components/profile_card.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import "../services/api/user-api.service.dart" as apiService;

class SwiperController extends StatefulWidget {
  SwiperController({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SwiperControllerState createState() => _SwiperControllerState();
}

class _SwiperControllerState extends State<SwiperController> {
  List<User> users = new List();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this._getUsers();
  }

  _getUsers() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await apiService.getUsers().then((users) {
      // printWrapped("Users: ");
      // print(jsonEncode(users));
      if (mounted) {
        setState(() {
          this.users = users;
          isLoading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          this.users = new List<User>();
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: (this.users.length > 0)
          ? new Swiper(
              layout: SwiperLayout.TINDER,
              itemWidth: screenSize.width - 20,
              itemHeight: screenSize.height - 20,
              itemBuilder: (BuildContext context, int index) {
                return new ProfileCardWidget(
                  user: this.users.length > index
                      ? this.users[index]
                      : new User(),
                );
              },
              itemCount: users.length,
              pagination: null,
              control: null,
            )
          : new Center(
              child: isLoading ? CircularProgressIndicator() : Center(),
            ),
    );
  }
}
