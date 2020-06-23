import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:true_ishq/components/profile_card.dart';
import 'package:true_ishq/enums/like_dislike.dart';
import 'package:true_ishq/models/user.dart';
import 'package:true_ishq/services/auth.service.dart';
import 'package:true_ishq/utilities/helpers.dart';
import "../services/api/user-api.service.dart" as apiService;

const DRAG_THRESHOLD = 170;

class ProfileCardDraggableWidget extends StatefulWidget {
  ProfileCardDraggableWidget(Key key, this.user, this.swipeActionComplete);

  final User user;
  final Function swipeActionComplete;

  @override
  _ProfileCardDraggableState createState() => _ProfileCardDraggableState();
}

class _ProfileCardDraggableState extends State<ProfileCardDraggableWidget> {
  Size _screenSize;
  double dragOriginalX = 0;
  GlobalKey<ProfileCardState> _profileCardKey = GlobalKey();
  AuthService authService;

  @override
  void initState() {
    super.initState();
  }

  void likeUser() async {
    dynamic response =
        await apiService.likeUser(authService.currentUser, widget.user);
    printWrapped('response in widget: ');
    printWrapped(response.toString());
  }

  void dislikeUser() async {}

  void cardSwiped(LikeDislike swipeResult) {
    widget.swipeActionComplete(swipeResult);
    if (swipeResult == LikeDislike.LIKE) {
      likeUser();
    } else {
      dislikeUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);

    _screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Listener(
          onPointerDown: (PointerEvent event) {
            // printWrapped('pointer down: ');
            // printWrapped(event.toString());
            dragOriginalX = event.position.dx;
          },
          onPointerMove: (PointerMoveEvent event) {
            // print('original x:');
            // print(dragOriginalX);
            // print(event.position);

            double deltaX = event.position.dx - dragOriginalX;
            if (deltaX >= 0) {
              // Dragging right
              _profileCardKey.currentState.updateSwipingState(LikeDislike.LIKE);
            } else {
              // Dragging left
              _profileCardKey.currentState
                  .updateSwipingState(LikeDislike.DISLIKE);
            }
          },
          child: Draggable(
            onDragEnd: (drag) {
              // printWrapped('drag ended');
              // printWrapped(drag.offset.toString());
              
              bool isDragComplete = false;
              LikeDislike swipeResult;

              if (drag.offset.dx < -DRAG_THRESHOLD) {
                // Swiped left
                isDragComplete = true;
                swipeResult = LikeDislike.DISLIKE;
              } else if (drag.offset.dx > DRAG_THRESHOLD) {
                // Swiped right
                isDragComplete = true;
                swipeResult = LikeDislike.LIKE;
              }

              if (isDragComplete) {
                cardSwiped(swipeResult);
                // this.users.removeAt(x);
                // _removeCard(x);
                // setState(() {
                //   swipingState = null;
                // });
              }
            },
            onDragStarted: () {},
            onDragCompleted: () {},
            childWhenDragging: Container(
              width: 400,
              height: _screenSize.height - (0.3 * _screenSize.height),
            ),
            feedback: _getDraggableFeedback(
              widget.user,
            ),
            child: new ProfileCardWidget(
              null,
              widget.user,
            ),
            data: widget.user.id,
          ),
        ),
        _getUserActions()
      ],
    );
  }

  Widget _getDraggableFeedback(User user) {
    return Stack(
      // fit: StackFit.expand,
      overflow: Overflow.clip,
      children: <Widget>[
        Container(
          child: new ProfileCardWidget(
            _profileCardKey,
            user,
          ),
          width: _screenSize.width,
          height: _screenSize.height - (0.1116 * _screenSize.height),
        ),
      ],
    );
  }

  Widget _getUserActions() {
    return new Positioned(
      child: new Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 25),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new RawMaterialButton(
                onPressed: () {
                  // swipeRight(false);
                },
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
                onPressed: () {
                  cardSwiped(LikeDislike.LIKE);
                },
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
    );
  }
}
