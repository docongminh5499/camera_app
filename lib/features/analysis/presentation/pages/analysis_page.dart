import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/analysis/presentation/bloc/analysis_bloc.dart';
import 'package:my_camera_app_demo/features/analysis/presentation/pages/result_page.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/camera/presentation/pages/camera_page.dart';
import 'package:my_camera_app_demo/features/gallery/presentation/pages/choose_gallery_page.dart';
import 'package:my_camera_app_demo/injections/injection.dart';

class AnalysisPage extends StatefulWidget {
  final Color themeColor;
  AnalysisPage({Key key, this.themeColor}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String imageBase64;
  AnalysisBloc bloc = sl<AnalysisBloc>();
  bool popUp = false;

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void onChoosePicture() async {
    ImagePicker picker = ImagePicker();
    XFile _file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (_file != null) bloc.add(ChoosePictureEvent(file: File(_file.path)));
  }

  void onChooseGallery() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseGalleryPage(
          themeColor: getAppBlocState().setting.isDarkModeOn
              ? Color(0xFF344860)
              : Color(0xFF95A5A5),
        ),
      ),
    );
    if (result != null)
      bloc.add(ChoosePictureFromGalleryEvent(fileBase64: result.data));
  }

  void onAnalysisPicture() async {
    AppLocalizations localizations = Constants.localizations;
    if (imageBase64 != null) {
      bloc.add(AnalysisPictureEvent(
        jwt: getAppBlocState().currentUser.jwt,
        userId: getAppBlocState().currentUser.id,
        data: imageBase64,
        analysisTime: DateTime.now().toUtc(),
      ));
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(localizations.translate('notChoosePictureYet')),
            actions: [
              TextButton(
                child: Text(
                  localizations.translate('close'),
                  style: TextStyle(
                    color: getAppBlocState().setting.isDarkModeOn
                        ? Color(0xFFBB6122)
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;

    return BlocProvider(
      create: (BuildContext context) => bloc,
      child: DecorateTitleScaffold(
        color: widget.themeColor,
        title: localizations.translate('analysis'),
        body: Column(
          children: [
            SizedBox(height: 50),
            BlocListener(
              bloc: bloc,
              listener: (BuildContext context, AnalysisState state) {
                if (popUp) {
                  Navigator.of(context).pop();
                  popUp = false;
                }

                if (state is AnalysisLoadedPicture) {
                  imageBase64 = state.fileBase64;
                } else if (state is AnalysisingPicture) {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                      );
                    },
                  );
                  popUp = true;
                } else if (state is AnalysisPictureSuccess) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ResultPage(themeColor: widget.themeColor),
                    ),
                  );
                } else if (state is AnalysisPictureError) {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(localizations.translate('analysisError')),
                        actions: [
                          TextButton(
                            child: Text(
                              localizations.translate('close'),
                              style: TextStyle(
                                color: getAppBlocState().setting.isDarkModeOn
                                    ? Color(0xFFBB6122)
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Expanded(
                child: BlocBuilder<AnalysisBloc, AnalysisState>(
                  builder: (BuildContext context, AnalysisState state) {
                    if (state is AnalysisInitial) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            localizations.translate('notChoosePictureYet'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    } else if (state is AnalysisLoadingPicture) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      );
                    }
                    return Image.memory(
                      base64Decode(imageBase64),
                      gaplessPlayback: true,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onChoosePicture,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(widget.themeColor)),
                  child: Text(localizations.translate('fromPhone')),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: onChooseGallery,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(widget.themeColor)),
                  child: Text(localizations.translate('fromGallery')),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: onAnalysisPicture,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(widget.themeColor)),
                  child: Text(localizations.translate('analysisPicture')),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
