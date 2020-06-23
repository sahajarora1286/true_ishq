import 'package:provider/provider.dart';
import 'package:true_ishq/components/profile_card_draggable.dart';
import 'package:true_ishq/enums/like_dislike.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:true_ishq/services/auth.service.dart';
import "../services/api/user-api.service.dart" as apiService;

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
      if (mounted) {
        setState(() {
          this.users = users;

          // cardList = _getMatchCard();

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

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  void _swipeActionComplete(LikeDislike swipeResult, int userIndex) {
    setState(() {
      this.users.removeAt(userIndex);
    });

    // _removeCard(userIndex);
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
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Material(
            elevation: 30,
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
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
        ],
      ),
      body: (this.users.length > 0)
          ? new Stack(
              alignment: Alignment.center,
              children: [
                for (int x = 0; x < this.users.length; x++)
                  Container(
                    child: ProfileCardDraggableWidget(widget.key, this.users[x],
                        (LikeDislike swipeResult) {
                      this._swipeActionComplete(swipeResult, x);
                    }),
                  ),
              ],
            )
          : new Center(
              child: isLoading ? CircularProgressIndicator() : Center(),
            ),
    );
  }
}
