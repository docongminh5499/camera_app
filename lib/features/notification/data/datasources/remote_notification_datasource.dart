import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/notification/data/models/number_notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_camera_app_demo/features/notification/data/models/open_notification_model.dart';

abstract class RemoteNotificationDatasource {
  Future<NotificationNumberModel> getUnopenNotificationNumber(String jwt);
  Future<OpenNotificationStatusModel> openAllNotification(String jwt);
}

class RemoteNotificationDatasourceImpl implements RemoteNotificationDatasource {
  final http.Client client;
  RemoteNotificationDatasourceImpl({@required this.client});

  @override
  Future<NotificationNumberModel> getUnopenNotificationNumber(
    String jwt,
  ) async {
    final response = await client.post(
      Uri.parse(Constants.urls['checkUnopenNotification']),
      body: {'token': jwt},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200)
      return NotificationNumberModel.fromJson(json.decode(response.body));
    throw GetUnopenNotificationException();
  }

  @override
  Future<OpenNotificationStatusModel> openAllNotification(String jwt) async {
    final response = await client.post(
      Uri.parse(Constants.urls['openAllNotification']),
      body: {'token': jwt},
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200)
      return OpenNotificationStatusModel.fromJson(json.decode(response.body));
    throw OpenAlNotificationException();
  }
}
