import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/export_picture_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/get_picture_usecase.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/param.dart';
import 'package:my_camera_app_demo/features/gallery/domain/usecases/send_sync_usecase.dart';
part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final SendSyncUsecase sendSyncUsecase;
  final GetPictureUsecase getPictureUsecase;
  final ExportPictureUsecase exportPictureUsecase;

  GalleryBloc({
    @required this.sendSyncUsecase,
    @required this.getPictureUsecase,
    @required this.exportPictureUsecase,
  }) : super(GalleryLoadingPicture());
  @override
  Stream<GalleryState> mapEventToState(GalleryEvent event) async* {
    if (event is GalleryLoadingEvent) {
      yield GalleryLoadingPicture();
      await sendSyncUsecase(SendSyncParams(
        jwt: event.jwt,
        userId: event.userId,
      ));
      final result = await getPictureUsecase(GetPictureParams(
        jwt: event.jwt,
        userId: event.userId,
        limit: event.limit,
        skip: 0,
      ));
      yield result.fold(
        (failure) => GalleryFirstLoadError(),
        (pictures) => GalleryLoadedPicture(
          items: pictures,
          endOfList: pictures.length < Constants.limitPicturePerRequest,
        ),
      );
    } else if (event is GalleryContinueLoadingEvent) {
      final result = await getPictureUsecase(GetPictureParams(
        jwt: event.jwt,
        userId: event.userId,
        limit: event.limit,
        skip: event.skip,
      ));
      yield result.fold(
        (failure) => GalleryContinueError(),
        (pictures) => GalleryContinueLoaded(
          items: pictures,
          endOfList: pictures.length < Constants.limitPicturePerRequest,
        ),
      );
    } else if (event is GalleryRefreshEvent) {
      await sendSyncUsecase(SendSyncParams(
        jwt: event.jwt,
        userId: event.userId,
      ));
      final result = await getPictureUsecase(GetPictureParams(
        jwt: event.jwt,
        userId: event.userId,
        limit: event.limit,
        skip: 0,
      ));
      Random random = new Random();
      yield result.fold(
        (failure) => GalleryRefreshError(),
        (pictures) => GalleryRefreshed(
          id: random.nextInt(100),
          items: pictures,
          endOfList: pictures.length < Constants.limitPicturePerRequest,
        ),
      );
    } else if (event is GalleryExportEvent) {
      yield GalleryExporting();
      await exportPictureUsecase(ExportPictureParams(
        pictures: event.pictures,
      ));
      yield GalleryExported();
    }
  }
}
