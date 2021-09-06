part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class ChoosePictureEvent extends AnalysisEvent {
  final File file;
  ChoosePictureEvent({@required this.file});
  @override
  List<Object> get props => <dynamic>[file];
}

class ChoosePictureFromGalleryEvent extends AnalysisEvent {
  final String fileBase64;
  ChoosePictureFromGalleryEvent({@required this.fileBase64});
  @override
  List<Object> get props => <dynamic>[fileBase64];
}

class AnalysisPictureEvent extends AnalysisEvent {
  final String jwt;
  final String userId;
  final String data;
  final DateTime analysisTime;

  AnalysisPictureEvent({
    @required this.jwt,
    @required this.userId,
    @required this.data,
    @required this.analysisTime,
  });
  @override
  List<Object> get props => <dynamic>[jwt, userId, data, analysisTime];
}
