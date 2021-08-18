import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camera_app_demo/cores/failures/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class NoFailureUsecase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams extends Equatable {
  static NoParams _instance = NoParams._internal();
  NoParams._internal();

  factory NoParams() {
    return _instance;
  }

  @override
  List<Object> get props => <dynamic>[];
}
