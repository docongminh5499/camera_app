import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/camera/data/models/picture_model.dart';
import 'package:my_camera_app_demo/features/gallery/data/models/deleted_items_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteGalleryDatasource {
  Future<PictureModel> syncCreate(String jwt, PictureModel model);
  Future<DeletedItemModel> syncDelete(String jwt, DeletedItemModel model);
  Future<List<PictureModel>> getPicture(String jwt, int limit, int skip);
  Future<List<PictureModel>> requireSyncCreate(
    String jwt,
    DateTime start,
    DateTime end,
  );
  Future<List<DeletedItemModel>> requireSyncDelete(
    String jwt,
    DateTime start,
    DateTime end,
  );
}

class RemoteGalleryDatasourceImpl implements RemoteGalleryDatasource {
  final http.Client client;
  RemoteGalleryDatasourceImpl({@required this.client});

  @override
  Future<PictureModel> syncCreate(String jwt, PictureModel model) async {
    Map<String, dynamic> data = model.toJson(
      notNull: true,
      parseString: true,
    );
    data['token'] = jwt;

    final response = await client
        .post(
          Uri.parse(Constants.urls['syncCreate']),
          body: data,
        )
        .timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
    if (response.statusCode == 200)
      return PictureModel.fromJson(json.decode(response.body));
    throw RemoteGalleryException();
  }

  @override
  Future<DeletedItemModel> syncDelete(
      String jwt, DeletedItemModel model) async {
    Map<String, dynamic> data = model.toJson(
      parseString: true,
      notNull: true,
    );
    data['token'] = jwt;
    final response = await client
        .post(
          Uri.parse(Constants.urls['syncDelete']),
          body: data,
        )
        .timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
    if (response.statusCode == 200)
      return DeletedItemModel.fromJson(json.decode(response.body));
    throw RemoteGalleryException();
  }

  @override
  Future<List<PictureModel>> getPicture(String jwt, int limit, int skip) async {
    final response = await client.post(
      Uri.parse(Constants.urls['getPicture']),
      body: {
        'token': jwt,
        'limit': limit.toString(),
        'skip': skip.toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final list = json.decode(response.body)['data'];
      return List.generate(
        list.length,
        (index) => PictureModel.fromJson(list[index]),
      );
    }
    throw RemoteGalleryException();
  }

  @override
  Future<List<PictureModel>> requireSyncCreate(
    String jwt,
    DateTime start,
    DateTime end,
  ) async {
    final response = await client.post(
      Uri.parse(Constants.urls['requireSyncCreate']),
      body: {
        'token': jwt,
        'start': start.toUtc().toString(),
        'end': end.toUtc().toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );

    if (response.statusCode == 200) {
      final list = json.decode(response.body)['created'];
      return List.generate(
        list.length,
        (index) => PictureModel.fromJson(list[index]),
      );
    }
    throw RemoteGalleryException();
  }

  @override
  Future<List<DeletedItemModel>> requireSyncDelete(
    String jwt,
    DateTime start,
    DateTime end,
  ) async {
    final response = await client.post(
      Uri.parse(Constants.urls['requireSyncDelete']),
      body: {
        'token': jwt,
        'start': start.toUtc().toString(),
        'end': end.toUtc().toString(),
      },
    ).timeout(
      Duration(seconds: Constants.timeoutSecond),
      onTimeout: () => http.Response('Error', 500),
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body)['deleted'];
      return List.generate(
        list.length,
        (index) => DeletedItemModel.fromJson(list[index]),
      );
    }
    throw RemoteGalleryException();
  }
}
