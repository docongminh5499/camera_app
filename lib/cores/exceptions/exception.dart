import 'package:flutter/cupertino.dart';

class LoginException implements Exception {}

class CacheException implements Exception {}

class SavePictureException implements Exception {}

class RemoteAccountException implements Exception {}

class CreateAccountException implements Exception {
  final int statusCode;
  CreateAccountException({@required this.statusCode});
}

class ModifyAccountException implements Exception {
  final int statusCode;
  ModifyAccountException({@required this.statusCode});
}

class RemoveAccountException implements Exception {
  final int statusCode;
  RemoveAccountException({@required this.statusCode});
}
