import 'dart:io';

import 'package:dio/dio.dart';
import 'package:true_ishq/configs/api.config.dart';
import 'package:true_ishq/models/user.dart';
import 'package:true_ishq/utilities/helpers.dart';
import 'package:http/http.dart' as http;
import "dart:convert" as convert;

import '../../configs/api.config.dart';
import '../../utilities/helpers.dart';

Future<User> createUser(User user) async {
  printWrapped("sending user json: ");
  printWrapped(convert.jsonEncode(user.toJson()));
  var uri = Uri.http(ApiConfig.apiUrl, '/api/users');

  http.Response response = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: convert.jsonEncode(user.toJson()),
  );

  printWrapped(response.body);
  printWrapped(response.statusCode.toString());

  if (response.statusCode == 200) {
    User user = User.fromJson(convert.jsonDecode(response.body));
    printWrapped("returning user: ");
    printWrapped(user.toString());
    return user;
  } else {
    throw convert.jsonDecode(response.body);
  }
}

Future<User> setProfilePicture(User user, File image) async {
  String url = ApiConfig.apiScheme +
      "://" +
      ApiConfig.apiUrl +
      "/api/users/setProfilePicture";
  Dio dio = new Dio();
  String fileName = image.path.split('/').last;

  FormData formData = FormData.fromMap({
    "files": await MultipartFile.fromFile(image.path, filename: fileName),
  });

  var queryParams = {
    '_id': user.id,
  };

  // queryParams.update("_id", user.id as dynamic);

  printWrapped("queryParams: ");
  printWrapped(queryParams.toString());

  Response response = await dio.post(url,
      data: formData,
      queryParameters: queryParams,
      options: Options(headers: {
        "Accept": "application/json"
      },
      responseType: ResponseType.json));

  printWrapped(response.toString());
  printWrapped(response.statusCode.toString());

  if (response.statusCode == 200) {
    user.profile.profilePic = response.data['url'];
    printWrapped("returning user: ");
    printWrapped(user.toString());
    return user;
  } else {
    throw convert.jsonDecode(response.data);
  }
}

Future<User> login(User user) async {
  var queryParameters = {'phone': user.phone, 'password': user.password};

  var uri = Uri.http(ApiConfig.apiUrl, '/api/users/login', queryParameters);

  http.Response response = await http.get(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
  );

  printWrapped(response.body);
  printWrapped(response.statusCode.toString());

  if (response.statusCode == 200) {
    return new User.fromJson(convert.jsonDecode(response.body));
  } else {
    throw convert.jsonDecode(convert.jsonDecode(response.body));
  }
}

Future<User> getUserByPhone(User user) async {
  var queryParameters = {
    'phone': user.phone,
  };

  var uri = Uri.http(ApiConfig.apiUrl, '/api/users', queryParameters);

  http.Response response = await http.get(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
  );

  printWrapped(response.body);
  printWrapped(response.statusCode.toString());

  if (response.statusCode == 200) {
    return new User.fromJson(convert.jsonDecode(response.body));
  } else {
    throw convert.jsonDecode(convert.jsonDecode(response.body));
  }
}

Future<List<User>> getUsers() async {
  var uri = Uri.http(ApiConfig.apiUrl, '/api/users');
  http.Response response = await http.get(
    uri,
    headers: {"Accept": "application/json"},
  );

  printWrapped(response.body);
  printWrapped(response.statusCode.toString());

  if (response.statusCode == 200) {
    List usersJson = convert.jsonDecode(response.body);
    List<User> users = usersJson.map((i) => User.fromJson(i)).toList();
    print("users list: ");
    print(convert.jsonEncode(users));
    return users;
  } else {
    throw convert.jsonDecode(convert.jsonDecode(response.body));
  }
}
