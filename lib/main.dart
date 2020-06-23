import 'package:provider/provider.dart';
import 'package:true_ishq/screens/custom_swiper.dart';
import 'package:true_ishq/screens/login_options.dart';
import 'package:flutter/material.dart';
import 'package:true_ishq/services/auth.service.dart';

import 'models/user.dart';
import 'screens/login_options.dart';
import 'screens/register_picture.dart';

// void main() => runApp(
//       ChangeNotifierProvider<AuthService>(
//         child: MyApp(),
//         create: (context) {
//           return AuthService();
//         },
//       ),
//     );

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (context) => new AuthService(),
      child: MaterialApp(
        title: "True Ishq",
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
            ),
          ),
          primaryIconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0
          ),
          backgroundColor: Color.fromRGBO(26, 26, 26, 1),
          primarySwatch: Colors.green,
          primaryColor: Color.fromRGBO(230, 191, 80, 1),
          accentColor: Colors.white,
          // buttonColor: Color.fromRGBO(36, 209, 85, 1),
          buttonColor: Color.fromRGBO(230, 191, 80, 1),
          buttonTheme: ButtonThemeData(
            minWidth: 180,
            buttonColor: Color.fromRGBO(230, 191, 80, 1),
            height: 50,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            highlightColor: Colors.orange,
            textTheme: ButtonTextTheme.accent,
          ),
          textTheme: TextTheme(
            button: TextStyle(
                color: Colors.white,
                decorationColor: Colors.white,
                fontSize: 17),
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, child) {
            return FutureBuilder(
              future: authService.getUser(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  User currentUser = snapshot.data;

                  if (currentUser == null) {
                    return LoginOptionsController(title: "True Ishq");
                  }

                  if (currentUser.profile.profilePic == null) {
                    return RegisterPictureController(
                        title: "Profile", user: currentUser);
                  }
                  // return MySwiperController(title: "True Ishq");
                  return CustomSwiperController(
                    title: "True Ishq",
                  );
                } else {
                  return LoginOptionsController(title: "True Ishq");
                }
              },
            );
          },
        ),
      ),
    );

    // return MaterialApp(
    //   title: 'True Ishq',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // Try running your application with "flutter run". You'll see the
    //     // application has a blue toolbar. Then, without quitting the app, try
    //     // changing the primarySwatch below to Colors.green and then invoke
    //     // "hot reload" (press "r" in the console where you ran "flutter run",
    //     // or simply save your changes to "hot reload" in a Flutter IDE).
    //     // Notice that the counter didn't reset back to zero; the application
    //     // is not restarted.
    //     primarySwatch: Colors.green,
    //   ),
    //   home: FutureBuilder(
    //     future: Provider.of<AuthService>(context).getUser(),
    // builder: (context, AsyncSnapshot snapshot) {
    //   if (snapshot.connectionState == ConnectionState.done) {
    //     return snapshot.hasData
    //         ? SwiperController(title: "True Ishq")
    //         : LoginOptionsController(title: "True Ishq");
    //   } else {
    //     return LoginOptionsController(title: "True Ishq");
    //   }
    // },
    //   ),
    // );
  }
}
