import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/features/analysis/domain/usecases/analysis_picture_usecase.dart';
import 'package:my_camera_app_demo/features/analysis/domain/usecases/param.dart';
part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisPictureUsecase usecase;
  AnalysisBloc({@required this.usecase}) : super(AnalysisInitial());

  @override
  Stream<AnalysisState> mapEventToState(AnalysisEvent event) async* {
    if (event is ChoosePictureEvent) {
      yield AnalysisLoadingPicture();
      final bytesList = await event.file.readAsBytes();
      final fileBase64 = base64Encode(bytesList);
      yield AnalysisLoadedPicture(fileBase64: fileBase64);
    } else if (event is ChoosePictureFromGalleryEvent) {
      yield AnalysisLoadingPicture();
      yield AnalysisLoadedPicture(fileBase64: event.fileBase64);
    } else if (event is AnalysisPictureEvent) {
      yield AnalysisingPicture();
      final result = await usecase(AnalysisPictureParams(
        jwt: event.jwt,
        userId: event.userId,
        data: event.data,
        analysisTime: event.analysisTime,
      ));
      yield result.fold(
        (failure) => AnalysisPictureError(),
        (unit) => AnalysisPictureSuccess(),
      );
    }
  }
}
