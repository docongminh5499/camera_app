part of 'camera_bloc.dart';

@immutable
abstract class CameraState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {}

class CameraError extends CameraState {}

class CameraTakePicureError extends CameraState {
  final String message;
  CameraTakePicureError({@required this.message});

  @override
  List<Object> get props => <dynamic>[message];
}
