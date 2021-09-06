part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoadingPicture extends AnalysisState {}

class AnalysisLoadedPicture extends AnalysisState {
  final String fileBase64;
  AnalysisLoadedPicture({@required this.fileBase64});
  @override
  List<Object> get props => <dynamic>[fileBase64];
}

class AnalysisingPicture extends AnalysisState {}

class AnalysisPictureSuccess extends AnalysisState {}

class AnalysisPictureError extends AnalysisState {}
