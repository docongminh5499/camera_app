import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteCameraDatasource {
  Future<void> sendPicture(String jwt, PictureModel model);
}

class RemoteCameraDatasourceImpl implements RemoteCameraDatasource {
  final http.Client client;
  RemoteCameraDatasourceImpl({@required this.client});

  @override
  Future<void> sendPicture(String jwt, PictureModel model) async {
    final response = await client.post(
      Uri.parse(Constants.urls['saveImage']),
      body: {
        'token': jwt,
        'userId': model.userId,
        'data': model.data,
        'lastModifyTime': model.lastModifyTime.toUtc().toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (!(response.statusCode == 200)) {
      throw RemoteSavePictureException();
    }
  }
}
