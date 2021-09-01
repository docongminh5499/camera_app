import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/features/notification/domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    @required String id,
    @required String senderId,
    @required String senderUsername,
    @required String message,
    @required DateTime sendTime,
    @required bool read,
  }) : super(
          id: id,
          senderId: senderId,
          senderUsername: senderUsername,
          message: message,
          sendTime: sendTime,
          read: read,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      senderId: json['senderId']['_id'],
      senderUsername: json['senderId']['username'],
      message: json['message'],
      sendTime: DateTime.parse(json['sendTime']).toLocal(),
      read: json['read'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson({bool notNull = false, parseString = false}) {
    Map<String, dynamic> json = {
      'id': id,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'message': message,
      'sendTime': sendTime.toUtc(),
      'read': read
    };
    if (notNull) {
      json.removeWhere((key, value) => value == null);
    }
    if (parseString) {
      json['sendTime'] = json['sendTime'].toString();
      json['read'] = json['read'].toString();
    }
    return json;
  }
}
