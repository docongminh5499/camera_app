import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/cores/widgets/decorate_title_scaffold.dart';
import 'package:my_camera_app_demo/features/analysis/presentation/pages/result_page.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/camera/presentation/pages/camera_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class AnalysisPage extends StatefulWidget {
  final Color themeColor;
  AnalysisPage({Key key, this.themeColor}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  File image;

  AppBloc getAppBloc() {
    return BlocProvider.of<AppBloc>(context);
  }

  LoggedInState getAppBlocState() {
    AppBloc bloc = getAppBloc();
    return bloc.state;
  }

  void onChoosePicture() async {
    ImagePicker picker = ImagePicker();
    XFile _file = await picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      image = File(_file.path);
    });
  }

  void onAnalysisPicture() async {
    AppLocalizations localizations = Constants.localizations;

    if (image != null) {
      Uri url = Uri.parse(Constants.urls["analysisImage"]);
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        "x-access-token": getAppBlocState().currentUser.jwt
      };
      request.files.add(
        http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: "image_file_name",
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
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
      var response = await request.send();
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultPage(themeColor: widget.themeColor),
          ),
        );
      } else {
        print(response.statusCode);
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
    }
  }

  Widget getPreviewImage(context) {
    AppLocalizations localizations = Constants.localizations;
    if (image == null)
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
    return Image.file(image);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;

    return DecorateTitleScaffold(
      color: widget.themeColor,
      title: localizations.translate('analysis'),
      body: Column(
        children: [
          SizedBox(height: 50),
          Expanded(child: getPreviewImage(context)),
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
                child: Text(localizations.translate('choosePicture')),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(widget.themeColor)),
                child: Text(localizations.translate('openCamera')),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: image == null ? null : onAnalysisPicture,
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
    );
  }
}
