import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/account/data/models/account_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteAccountDatasource {
  Future<List<AccountModel>> getListAccount(String jwt);
  Future<AccountModel> addAccount(
      String jwt, String username, String password, bool admin);
  Future<AccountModel> modifyAccount(
      String jwt, String id, String username, bool admin);
  Future<AccountModel> removeAccount(String jwt, String id);
}

class RemoteAccountDatasourceImpl implements RemoteAccountDatasource {
  final http.Client client;
  RemoteAccountDatasourceImpl({@required this.client});

  Future<List<AccountModel>> getListAccount(String jwt) async {
    final response = await client.post(
      Uri.parse(Constants.urls['getAccount']),
      body: {'token': jwt},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> accounts = data["accounts"];
      return accounts.map((account) => AccountModel.fromJson(account)).toList();
    } else
      throw RemoteAccountException();
  }

  @override
  Future<AccountModel> addAccount(
      String jwt, String username, String password, bool admin) async {
    final response = await client.post(
      Uri.parse(Constants.urls['addAccount']),
      body: {
        'token': jwt,
        'username': username,
        'password': password,
        'admin': admin.toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      return AccountModel.fromJson(json.decode(response.body));
    } else
      throw CreateAccountException(statusCode: response.statusCode);
  }

  @override
  Future<AccountModel> modifyAccount(
      String jwt, String id, String username, bool admin) async {
    final response = await client.post(
      Uri.parse(Constants.urls['modifyAccount']),
      body: {
        'token': jwt,
        'username': username,
        'id': id,
        'admin': admin.toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      return AccountModel.fromJson(json.decode(response.body));
    } else
      throw ModifyAccountException(statusCode: response.statusCode);
  }

  @override
  Future<AccountModel> removeAccount(String jwt, String id) async {
    final response = await client.post(
      Uri.parse(Constants.urls['removeAccount']),
      body: {'token': jwt, 'id': id},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      return AccountModel.fromJson(json.decode(response.body));
    } else
      throw RemoveAccountException(statusCode: response.statusCode);
  }
}
