import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';

abstract class RemoteAnalysisPictureDatasource {
  Future<void> analysisPicture(
    String jwt,
    String userId,
    String data,
    DateTime analysisTime,
  );
}

class RemoteAnalysisPictureDatasourceImpl
    implements RemoteAnalysisPictureDatasource {
  final http.Client client;
  RemoteAnalysisPictureDatasourceImpl({@required this.client});

  @override
  Future<void> analysisPicture(
      String jwt, String userId, String data, DateTime analysisTime) async {
    final response = await client.post(
      Uri.parse(Constants.urls['analysisImage']),
      body: {
        'token': jwt,
        'userId': userId,
        'data': data,
        'analysisTime': analysisTime.toUtc().toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (!(response.statusCode == 200)) {
      throw AnalysisPictureException(statusCode: response.statusCode);
    }
  }
}
