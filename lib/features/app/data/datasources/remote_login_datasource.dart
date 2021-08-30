import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteLoginDatasource {
  Future<UserModel> login(String username, String password);
  Future<bool> verifyJWT(UserModel user);
  Future<void> removeFirebaseToken(String jwt, String prevToken);
}

class RemoteLoginDataSourceImplmentation implements RemoteLoginDatasource {
  final http.Client client;

  RemoteLoginDataSourceImplmentation({@required this.client});

  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse(Constants.urls["login"]),
      body: {'username': username, 'password': password},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else
      throw LoginException();
  }

  Future<bool> verifyJWT(UserModel user) async {
    final response = await client.post(
      Uri.parse(Constants.urls["verifyToken"]),
      body: {'token': user.jwt},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      final remoteUser = UserModel.fromJson(json.decode(response.body));
      if (remoteUser.username == user.username) return true;
      return false;
    } else
      return false;
  }

  Future<void> removeFirebaseToken(String jwt, String prevToken) async {
    await client.post(
      Uri.parse(Constants.urls['removeFirebaseToken']),
      body: {'token': jwt, 'firebaseToken': prevToken},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );
  }
}
