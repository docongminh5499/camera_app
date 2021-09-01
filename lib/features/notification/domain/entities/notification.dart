import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderUsername;
  final String message;
  final DateTime sendTime;
  final bool read;

  NotificationEntity({
    @required this.id,
    @required this.senderId,
    @required this.senderUsername,
    @required this.message,
    @required this.sendTime,
    @required this.read,
  });

  @override
  List<Object> get props =>
      <dynamic>[id, senderId, senderUsername, message, sendTime, read];
}
