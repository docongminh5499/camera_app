part of 'gallery_bloc.dart';

@immutable
abstract class GalleryEvent extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class GalleryLoadingEvent extends GalleryEvent {
  final String jwt;
  final String userId;
  final int limit;

  GalleryLoadingEvent({
    @required this.jwt,
    @required this.userId,
    @required this.limit,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId, limit];
}

class GalleryContinueLoadingEvent extends GalleryEvent {
  final String jwt;
  final String userId;
  final int limit;
  final int skip;

  GalleryContinueLoadingEvent({
    @required this.jwt,
    @required this.userId,
    @required this.limit,
    @required this.skip,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId, limit, skip];
}

class GalleryRefreshEvent extends GalleryEvent {
  final String jwt;
  final String userId;
  final int limit;

  GalleryRefreshEvent({
    @required this.jwt,
    @required this.userId,
    @required this.limit,
  });

  @override
  List<Object> get props => <dynamic>[jwt, userId, limit];
}

class GalleryExportEvent extends GalleryEvent {
  final List<Picture> pictures;
  GalleryExportEvent({
    @required this.pictures,
  });

  @override
  List<Object> get props => <dynamic>[pictures];
}
