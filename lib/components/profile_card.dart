import 'dart:convert';

import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({Key key, this.user}) : super(key: key);

  final User user;
  String image = "assets/images/sahaj1.jpg";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var cardWidth = 400;

    return new Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            width: screenSize.width / 1.2 + cardWidth,
            decoration: new BoxDecoration(
              // color: new Color.fromRGBO(121, 114, 173, 1.0),
              color: Colors.white,
              borderRadius: new BorderRadius.circular(8.0),
            ),
            child: new Column(
              children: <Widget>[
                new Container(
                  width: screenSize.width / 1.2 + cardWidth,
                  height: screenSize.height / 1.8,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(8.0),
                        topRight: new Radius.circular(8.0)),
                    image: new DecorationImage(
                      image: user.profile.profilePic != null
                          ? new NetworkImage(user.profile.profilePic)
                          : new ExactAssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                new Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(20.0),
                  child: new Text(
                    user.profile.firstName,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                new Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
                  child: new Text(
                    user.profile.occupation,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                new Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
                  child: new Text(
                    user.profile.description != null
                        ? user.profile.description
                        : '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            child: new Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new RawMaterialButton(
                      onPressed: () {},
                      child: new Icon(
                        Icons.close,
                        color: Colors.blue,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    new RawMaterialButton(
                      onPressed: () {},
                      child: new Icon(
                        Icons.flash_on,
                        color: Colors.purple,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    new RawMaterialButton(
                      onPressed: () {},
                      child: new Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
