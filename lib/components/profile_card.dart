import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:true_ishq/utilities/helpers.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({Key key, this.user, this.swiperController})
      : super(key: key);

  final User user;
  final SwiperController swiperController;

  String image = "assets/images/placeholders/person.jpg";

  void swipeRight(bool isLike) {
    printWrapped('swiping right');
    swiperController.next(animation: true);
  }

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
                Expanded(
                  flex: 2,
                  child: new Container(
                    width: screenSize.width / 1.2 + cardWidth,
                    height: screenSize.height - (0.5 * screenSize.height),
                    // decoration: new BoxDecoration(
                    //   borderRadius: new BorderRadius.only(
                    //       topLeft: new Radius.circular(8.0),
                    //       topRight: new Radius.circular(8.0)),
                    //   image: new DecorationImage(
                    //     image: user.profile.profilePic != null
                    //         ?
                    //         //  new NetworkImage(user.profile.profilePic)
                    //         // ? new ExactAssetImage(image)
                    //         : new ExactAssetImage(image),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: new CachedNetworkImage(
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: user.profile.profilePic != null
                          ? user.profile.profilePic
                          : image,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
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
                          'This is my profile description. My profile is the best profile there is and there are no doubts about it.',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
