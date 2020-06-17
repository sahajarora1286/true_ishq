import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utilities/helpers.dart';
import "api/user-api.service.dart" as apiService;

class AuthService with ChangeNotifier {
  User currentUser;

  AuthService() {
    print("new AuthService");
  }

  Future getUser() {
    print('getting user');
    return Future.value(currentUser);
  }

  Future logout() {
    print('logging out');
    this.currentUser = null;
    notifyListeners();
    return Future.value(currentUser);
  }

  // wrapping the firebase calls
  Future createUser(User user) {
    return apiService.createUser(user).then((result) {
        this.currentUser = result;
      notifyListeners();
      return Future.value(currentUser);
    }).catchError((error) {
      return Future.value(null);
    });
  }

  // logs in the user
  Future loginUser(User user) {
    printWrapped("Logging in...");
    return apiService.login(user).then((result) {
      printWrapped("Result from login api call: ");
      printWrapped(result.toJson().toString());
      this.currentUser = result;
      notifyListeners();
      return Future.value(currentUser);
    }).catchError((error) {
      printWrapped(error);
      throw error;
      // return Future.value(null);
    });
  }
}
