import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/usecases/usecase.dart';
import 'package:my_camera_app_demo/features/analysis/domain/repositories/analysis_picture_repository.dart';
import 'package:my_camera_app_demo/features/analysis/domain/usecases/param.dart';

class AnalysisPictureUsecase extends Usecase<void, AnalysisPictureParams> {
  final AnalysisPictureRepository repository;
  AnalysisPictureUsecase({@required this.repository});

  @override
  Future<Either<Failure, void>> call(AnalysisPictureParams params) {
    return repository.analysisPicture(
      params.jwt,
      params.userId,
      params.data,
      params.analysisTime,
    );
  }
}
