part of 'gallery_bloc.dart';

@immutable
abstract class GalleryState extends Equatable {
  @override
  List<Object> get props => <dynamic>[];
}

class GalleryLoadingPicture extends GalleryState {}

class GalleryLoadedPicture extends GalleryState {
  final List<Picture> items;
  final bool endOfList;

  GalleryLoadedPicture({
    @required this.items,
    @required this.endOfList,
  });
  @override
  List<Object> get props => <dynamic>[items, endOfList];
}

class GalleryFirstLoadError extends GalleryState {}

class GalleryContinueLoading extends GalleryState {}

class GalleryContinueLoaded extends GalleryState {
  final List<Picture> items;
  final bool endOfList;

  GalleryContinueLoaded({
    @required this.items,
    @required this.endOfList,
  });
  @override
  List<Object> get props => <dynamic>[items, endOfList];
}

class GalleryContinueError extends GalleryState {}

class GalleryRefreshing extends GalleryState {}

class GalleryRefreshed extends GalleryState {
  final List<Picture> items;
  final bool endOfList;

  GalleryRefreshed({
    @required this.items,
    @required this.endOfList,
  });
  @override
  List<Object> get props => <dynamic>[items, endOfList];
}

class GalleryRefreshError extends GalleryState {}
