import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:true_ishq/enums/like_dislike.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatefulWidget {
  ProfileCardWidget(Key key, this.user) : super(key:key);

  final User user;

  final String image = "assets/images/placeholders/person.jpg";

  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCardWidget> {
  LikeDislike _swipingState;

  @override
  void initState() {
    super.initState();
  }

  updateSwipingState(LikeDislike swipingState) {
    setState(() {
      _swipingState = swipingState;
    });
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
                  child: new Stack(
                    overflow: Overflow.clip,
                    fit: StackFit.expand,
                    children: <Widget>[
                      new Container(
                        width: screenSize.width / 1.2 + cardWidth,
                        height: screenSize.height - (0.5 * screenSize.height),
                        child: new CachedNetworkImage(
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: widget.user.profile.profilePic != null
                              ? widget.user.profile.profilePic
                              : widget.image,
                        ),
                      ),
                      Visibility(
                        visible: _swipingState == LikeDislike.LIKE,
                        child: new Positioned(
                          top: 20,
                          left: 40,
                          child: _getLikeDislikeWidget(LikeDislike.LIKE),
                        ),
                      ),
                      Visibility(
                        visible: _swipingState == LikeDislike.DISLIKE,
                        child: new Positioned(
                          top: 20,
                          right: 40,
                          child: _getLikeDislikeWidget(LikeDislike.DISLIKE),
                        ),
                      ),
                    ],
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
                          widget.user.profile.firstName,
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
                          widget.user.profile.occupation,
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

  Widget _getLikeDislikeWidget(LikeDislike likeDislike) {
    return Container(
      child: Padding(
        child: Material(
          color: Colors.transparent,
          child: Text(
            likeDislike == LikeDislike.LIKE ? "LIKE" : "NOPE",
            style: TextStyle(
                color:
                    likeDislike == LikeDislike.LIKE ? Colors.green : Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.transparent),
          ),
        ),
        padding: EdgeInsets.all(15),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: likeDislike == LikeDislike.LIKE ? Colors.green : Colors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
