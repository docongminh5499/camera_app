import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/cached_jwt.dart';

class CachedJWTModel extends CachedJWT {
  CachedJWTModel({
    int id,
    @required String userId,
    @required String jwt,
  }) : super(id: id, userId: userId, jwt: jwt);

  factory CachedJWTModel.fromJson(Map<String, dynamic> json) {
    return CachedJWTModel(
      id: json['id'],
      userId: json['userId'],
      jwt: json['jwt'],
    );
  }

  Map<String, dynamic> toJson({bool notNull = false}) {
    Map<String, dynamic> json = {
      'id': id,
      'userId': userId,
      'jwt': jwt,
    };
    if (notNull) json.removeWhere((key, value) => value == null);
    return json;
  }
}
