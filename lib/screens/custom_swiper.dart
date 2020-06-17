import 'package:provider/provider.dart';
import 'package:true_ishq/components/profile_card.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:true_ishq/services/auth.service.dart';
import "../services/api/user-api.service.dart" as apiService;
import '../utilities/helpers.dart';

class CustomSwiperController extends StatefulWidget {
  CustomSwiperController({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CustomSwiperControllerState createState() => _CustomSwiperControllerState();
}

class _CustomSwiperControllerState extends State<CustomSwiperController> {
  List<User> users = new List();
  List<Widget> cardList;

  bool isLoading = false;
  AuthService authService;
  Size _screenSize;
  final double dragCompleteOffset = -80;
  int currentIndex = 0;

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

          cardList = _getMatchCard();

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

  Widget _getDragTarget() {
    return Container(
      child: DragTarget(
        builder: (context, List<String> candidateData, rejectedData) {
          return Container(
            color: Colors.black,
            height: 900,
            width: 600,
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (data) {
          printWrapped('acceptedddd');
          // accepted = true;
        },
      ),
    );
  }

  List<Widget> _getMatchCard() {
    List<Widget> cardList = new List();
    double margin = 0;

    // Left Drag Target
    // cardList.add(
    //   Positioned(
    //     left: 0,
    //     top: 0,
    //     child: _getDragTarget(),
    //     height: _screenSize.height,
    //     width: 800,
    //   ),
    // );

    // // Right Drag Taget
    // cardList.add(
    //   Positioned(
    //     right: 0,
    //     top: 0,
    //     child: _getDragTarget(),
    //     height: _screenSize.height,
    //     width: 800,
    //   ),
    // );

    for (int x = 0; x < this.users.length; x++) {
      cardList.add(
        Container(
          child: Draggable(
            onDragEnd: (drag) {
              printWrapped('drag ended');
              printWrapped(drag.offset.toString());

              bool shouldRemoveUser = false;
              if (drag.offset.dx < -150) {
                // Swiped left
                shouldRemoveUser = true;
              } else if (drag.offset.dx > 150) {
                // Swiped right
                shouldRemoveUser = true;
                likeUser(this.users[x]);
              }

              if (shouldRemoveUser) {
                this.users.removeAt(x);
                _removeCard(x);
              }
            },
            onDragCompleted: () {
              // printWrapped('drag complete');
              //  this.users.removeAt(x);
              // _removeCard(x);
            },
            childWhenDragging: Container(
              width: 400,
              height: _screenSize.height - (0.3 * _screenSize.height),
            ),
            feedback: Container(
              child: new ProfileCardWidget(
                user: this.users[x],
              ),
              width: _screenSize.width,
              height: _screenSize.height - (0.1116 * _screenSize.height),
            ),
            child: new ProfileCardWidget(
              user: this.users[x],
            ),
            data: this.users[x].id,
          ),
        ),
      );
    }

    cardList.add(
      new Positioned(
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
                    // swipeRight(true);
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
      ),
    );

    return cardList;
  }

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    printWrapped('swiper controller: currentUser: ');
    printWrapped(authService.currentUser.toJson().toString());

    _screenSize = MediaQuery.of(context).size;
    printWrapped("screen height: ");
    printWrapped(_screenSize.height.toString());

    bool accepted = false;

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        leading: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Material(
            shape: new CircleBorder(),
            child: Image(
              fit: BoxFit.cover,
              image: authService.currentUser.profile != null &&
                      authService.currentUser.profile.profilePic != null
                  ? new NetworkImage(authService.currentUser.profile.profilePic)
                  : new ExactAssetImage(
                      "assets/images/placeholders/person.jpg"),
            ),
            clipBehavior: Clip.antiAlias,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                authService.logout();
              },
              child: Icon(
                Icons.exit_to_app,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: (this.users.length > 0)
          ? new Stack(alignment: Alignment.center, children: cardList)
          : new Center(
              child: isLoading ? CircularProgressIndicator() : Center(),
            ),
    );
  }

  void likeUser(User user) async {
    dynamic response = await apiService.likeUser(authService.currentUser, user);
    printWrapped('response in widget: ');
    printWrapped(response.toString());
  }
}
