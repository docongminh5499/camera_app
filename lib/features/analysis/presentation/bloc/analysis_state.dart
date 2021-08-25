part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoadingPicture extends AnalysisState {}

class AnalysisLoadedPicture extends AnalysisState {
  final File file;
  AnalysisLoadedPicture({@required this.file});
  @override
  List<Object> get props => <dynamic>[file];
}

class AnalysisingPicture extends AnalysisState {}

class AnalysisPictureSuccess extends AnalysisState {}

class AnalysisPictureError extends AnalysisState {}
