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

  TakePictureEvent({@required this.path});

  @override
  List<Object> get props => <dynamic>[path];
}
