import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/account/domain/repositories/account_repository.dart';
import 'package:my_camera_app_demo/features/account/domain/usecases/param.dart';

class SendNotificationUsecase
    extends NoFailureUsecase<bool, SendNotificationParams> {
  AccountRepository repository;
  SendNotificationUsecase({@required this.repository});

  @override
  Future<bool> call(SendNotificationParams params) async {
    return await repository.sendNotification(
      params.jwt,
      params.receiverId,
      params.message,
    );
  }
}
