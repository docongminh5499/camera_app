part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class StartLoadCameraEvent extends CameraEvent {}

class LoadCameraEvent extends CameraEvent {}

class ErrorLoadCameraEvent extends CameraEvent {}

class TakePictureEvent extends CameraEvent {
  final String path;
  final String userId;
  final String jwt;

  TakePictureEvent({
    @required this.path,
    @required this.userId,
    @required this.jwt,
  });

  @override
  List<Object> get props => <dynamic>[path, userId, jwt];
}
