import 'package:provider/provider.dart';
import 'package:true_ishq/components/profile_card.dart';
import 'package:true_ishq/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:true_ishq/services/auth.service.dart';
import "../services/api/user-api.service.dart" as apiService;
import '../utilities/helpers.dart';

class MySwiperController extends StatefulWidget {
  MySwiperController({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MySwiperControllerState createState() => _MySwiperControllerState();
}

class _MySwiperControllerState extends State<MySwiperController> {
  List<User> users = new List();

  bool isLoading = false;
  AuthService authService;
  SwiperController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = new SwiperController();
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
    // authService = Provider.of<AuthService>(context);
    // printWrapped('swiper controller: currentUser: ');
    // printWrapped(authService.currentUser.toJson().toString());

    // Size screenSize = MediaQuery.of(context).size;

    // return new Scaffold(
    //   appBar: new AppBar(
    //     centerTitle: true,
    //     title: new Text(
    //       widget.title,
    //       textAlign: TextAlign.center,
    //     ),
    //     leading: new Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: new Material(
    //         shape: new CircleBorder(),
    //         child: Image(
    //           fit: BoxFit.cover,
    //           image: authService.currentUser.profile != null &&
    //                   authService.currentUser.profile.profilePic != null
    //               ? new NetworkImage(authService.currentUser.profile.profilePic)
    //               : new ExactAssetImage(
    //                   "assets/images/placeholders/person.jpg"),
    //         ),
    //         clipBehavior: Clip.antiAlias,
    //       ),
    //     ),
    //     actions: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.only(right: 20.0),
    //         child: GestureDetector(
    //           onTap: () {
    //             authService.logout();
    //           },
    //           child: Icon(
    //             Icons.exit_to_app,
    //             size: 26.0,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: (this.users.length > 0)
    //       ? new Swiper(
    //           layout: SwiperLayout.STACK,
    //           itemWidth: screenSize.width - 20,
    //           itemHeight: screenSize.height - 20,
    //           itemBuilder: (BuildContext context, int index) {
    //             return new ProfileCardWidget(
    //                 user: this.users.length > index
    //                     ? this.users[index]
    //                     : new User());
    //           },
    //           itemCount: users.length,
    //           pagination: null,
    //           controller: _controller,
    //           onIndexChanged: (int index) {
    //             setState(() {
    //               this.users.removeAt(index - 1);
    //             });

    //             likeUser(this.users[index - 1]);
    //           },
    //         )
    //       : new Center(
    //           child: isLoading ? CircularProgressIndicator() : Center(),
    //         ),
    // );
  }

  void likeUser(User user) async {
    dynamic response = await apiService.likeUser(authService.currentUser, user);
    printWrapped('response in widget: ');
    printWrapped(response.toString());
  }
}
