import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/camera/domain/usecases/params.dart';
import 'package:my_camera_app_demo/features/camera/domain/usecases/save_picture.dart';
part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  SavePictureUsecase savePictureUsecase;

  CameraBloc({
    @required this.savePictureUsecase,
  }) : super(CameraLoading());

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is StartLoadCameraEvent) {
      yield CameraLoading();
    } else if (event is LoadCameraEvent) {
      yield CameraLoaded();
    } else if (event is ErrorLoadCameraEvent) {
      yield CameraError();
    } else if (event is TakePictureEvent) {
      final result = await savePictureUsecase(SavePictureParams(
        path: event.path,
        userId: event.userId,
        jwt: event.jwt,
      ));
      yield result.fold((failure) {
        String message = Constants.localizations.translate("takePictureError");
        return CameraTakePicureError(message: message);
      }, (unit) => state);
    }
  }
}
