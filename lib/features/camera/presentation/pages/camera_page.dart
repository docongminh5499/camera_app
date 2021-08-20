import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camera_app_demo/cores/localize/app_localize.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/presentation/bloc/app_bloc.dart';
import 'package:my_camera_app_demo/features/camera/presentation/bloc/camera_bloc.dart';
import 'package:my_camera_app_demo/features/camera/presentation/widgets/my_button_icon.dart';
import 'package:my_camera_app_demo/injections/injection.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  List<CameraDescription> _cameras;
  CameraController _controller;
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  CameraBloc bloc;
  int _selected = 0;
  bool firstMount = true;

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
    bloc = sl<CameraBloc>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstMount) {
      setupCamera()
          .then((value) => bloc.add(LoadCameraEvent()))
          .onError((error, stackTrace) => bloc.add(ErrorLoadCameraEvent()));
      _animationController = AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this,
      );
      _opacityAnimation = TweenSequence(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween(begin: 1, end: 0.3), weight: 50),
        TweenSequenceItem<double>(tween: Tween(begin: 0.3, end: 1), weight: 50)
      ]).animate(_animationController);
      firstMount = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> setupCamera() async {
    _cameras = await availableCameras();
    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  selectCamera() async {
    var controller = CameraController(
        _cameras[_selected], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420);
    await controller.initialize();
    return controller;
  }

  toggleCamera() async {
    int newSelected = (_selected + 1) % _cameras.length;
    _selected = newSelected;

    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = Constants.localizations;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: BlocProvider(
          create: (context) => bloc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocListener(
                bloc: bloc,
                listener: (context, state) {
                  if (state is CameraTakePicureError) {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(state.message),
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
                child: BlocBuilder<CameraBloc, CameraState>(
                    builder: (BuildContext context, CameraState state) {
                  if (state is CameraLoading) {
                    return Expanded(
                        flex: 1,
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ));
                  } else if (state is CameraError) {
                    return Expanded(
                      flex: 1,
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 60,
                            color: Colors.red,
                          ),
                          SizedBox(height: 10),
                          Text(
                            localizations.translate('cameraError'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green,
                              ),
                            ),
                            onPressed: () {
                              bloc.add(StartLoadCameraEvent());
                              setupCamera()
                                  .then((value) => bloc.add(LoadCameraEvent()))
                                  .onError((error, stackTrace) =>
                                      bloc.add(ErrorLoadCameraEvent()));
                            },
                            child: Text(localizations.translate('tryAgain')),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      flex: 1,
                      child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, _) {
                            return Opacity(
                              opacity: _opacityAnimation.value,
                              child: CameraPreview(_controller),
                            );
                          }),
                    );
                  }
                }),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(color: Colors.black87),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButtonIcon(
                      onPress: () => Navigator.of(context).pop(),
                      icon: Icons.arrow_back,
                      iconSize: 24,
                    ),
                    MyButtonIcon(
                      onPress: () async {
                        if (_controller != null &&
                            _controller.value.isInitialized) {
                          if (await Permission.storage.status.isGranted) {
                            _animationController.reset();
                            _animationController.forward();
                            final image = await _controller.takePicture();
                            bloc.add(TakePictureEvent(
                              path: image.path,
                              userId: getAppBlocState().currentUser.id,
                              jwt: getAppBlocState().currentUser.jwt,
                            ));
                          } else if (await Permission.storage.status.isDenied) {
                            await Permission.storage.request();
                          }
                        }
                      },
                      icon: Icons.camera_alt,
                      iconSize: 50,
                    ),
                    MyButtonIcon(
                      onPress: toggleCamera,
                      icon: Icons.flip_camera_android,
                      iconSize: 24,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
