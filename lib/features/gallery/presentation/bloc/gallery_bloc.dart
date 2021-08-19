import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'gallery_event.dart';
part 'gallery_state.dart';
class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(GalleryInitial());
  @override
  Stream<GalleryState> mapEventToState(
    GalleryEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
