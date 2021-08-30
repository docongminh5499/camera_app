import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/camera/domain/entities/picture.dart';
import 'package:my_camera_app_demo/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:my_camera_app_demo/features/gallery/presentation/widgets/gallery_item.dart';
import 'package:my_camera_app_demo/features/gallery/presentation/widgets/loading_item.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class GalleryPage extends StatefulWidget {
  final Color themeColor;
  GalleryPage({
    Key key,
    @required this.themeColor,
  }) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool firstMount = true;
  bool endOfList = false;
  bool refreshing = false;
  double scrollThreshold = 50.0;
  List<Picture> items = [];
  GalleryBloc bloc = sl<GalleryBloc>();
  ScrollController controller = new ScrollController();

  Future<void> onRefreshGallery() async {
    refreshing = true;
    bloc.add(GalleryRefreshEvent(
      jwt: getAppBlocState().currentUser.jwt,
      userId: getAppBlocState().currentUser.id,
      limit: Constants.limitPicturePerRequest,
    ));
    while (refreshing) {
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void onScrollEnd() {
    final extentAfter = controller.position.extentAfter;
    if (extentAfter < scrollThreshold && !endOfList) {
      bloc.add(GalleryContinueLoadingEvent(
        jwt: getAppBlocState().currentUser.jwt,
        userId: getAppBlocState().currentUser.id,
        limit: Constants.limitPicturePerRequest,
        skip: items.length,
      ));
    }
  }

  void firstLoading() {
    bloc.add(GalleryLoadingEvent(
      jwt: getAppBlocState().currentUser.jwt,
      userId: getAppBlocState().currentUser.id,
      limit: Constants.limitPicturePerRequest,
    ));
  }

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScrollEnd);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstMount) {
      firstLoading();
      firstMount = false;
    }
  }

  @override
  void dispose() {
    controller.removeListener(onScrollEnd);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('gallery'),
        body: Padding(
          padding: EdgeInsets.only(top: 50),
          child: BlocListener(
            bloc: bloc,
            listener: (context, state) {
              if (state is GalleryLoadedPicture) {
                items = state.items;
                endOfList = state.endOfList;
              } else if (state is GalleryRefreshed) {
                refreshing = false;
                items = state.items;
                endOfList = state.endOfList;
              } else if (state is GalleryRefreshError) {
                refreshing = false;
              } else if (state is GalleryContinueLoaded) {
                items.addAll(state.items);
                endOfList = state.endOfList;
              }
            },
            child: BlocBuilder<GalleryBloc, GalleryState>(
              builder: (context, state) {
                if (state is GalleryLoadingPicture) {
                  return Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  );
                } else if (state is GalleryFirstLoadError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('analysisError'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widget.themeColor,
                          ),
                        ),
                        onPressed: firstLoading,
                        child: Text(localizations.translate('tryAgain')),
                      ),
                    ],
                  );
                }

                if (items.isEmpty) {
                  return Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.translate('galleryEmpty'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: onRefreshGallery,
                  child: GridView.builder(
                    controller: controller,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: endOfList ? items.length : items.length + 1,
                    itemBuilder: (BuildContext ctx, index) {
                      if (index == items.length)
                        return GalleryLoadingItem(
                          themeColor: widget.themeColor,
                        );
                      return GalleryItem(
                        key: ValueKey(items[index].serverId ?? items[index].id),
                        data: items[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
