import 'package:flutter/cupertino.dart';
import 'package:my_camera_app_demo/cores/exceptions/exception.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:my_camera_app_demo/cores/network/network_info.dart';
import 'package:my_camera_app_demo/features/analysis/data/datasources/remote_analysis_datasource.dart';
import 'package:my_camera_app_demo/features/analysis/domain/repositories/analysis_picture_repository.dart';

class AnalysisPictureRepositoryImpl implements AnalysisPictureRepository {
  final RemoteAnalysisPictureDatasource datasource;
  final NetworkInfo networkInfo;
  AnalysisPictureRepositoryImpl({
    @required this.datasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> analysisPicture(
    String jwt,
    String userId,
    String data,
    DateTime analysisTime,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        await datasource.analysisPicture(jwt, userId, data, analysisTime);
        return Right(Unit);
      }
      throw AnalysisPictureException(statusCode: 500);
    } on AnalysisPictureException catch (error, _) {
      return Left(AnalysisPictureFailure(statusCode: error.statusCode));
    }
  }
}
