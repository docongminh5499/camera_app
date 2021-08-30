import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_camera_app_demo/cores/utils/constants.dart';
import 'package:my_camera_app_demo/features/app/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHandler {
  FirebaseApp app;
  FirebaseMessaging messaging;
  NotificationSettings settings;
  SharedPreferences preferences;
  http.Client client;

  FirebaseHandler({
    @required this.preferences,
    @required this.client,
  });

  Future<FirebaseApp> initialApp() async {
    if (app == null) app = await Firebase.initializeApp();
    return app;
  }

  void getToken(User user) {
    messaging.getToken().then((token) async {
      String prevToken = preferences.getString(Constants.firebaseKey);
      if (prevToken == null) {
        await client.post(
          Uri.parse(Constants.urls['registerFirebaseToken']),
          body: {'token': user.jwt, 'firebaseToken': token},
        ).timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
        preferences.setString(Constants.firebaseKey, token);
      } else if (prevToken != token) {
        await client.post(
          Uri.parse(Constants.urls['removeFirebaseToken']),
          body: {'token': user.jwt, 'firebaseToken': prevToken},
        ).timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
        await client.post(
          Uri.parse(Constants.urls['registerFirebaseToken']),
          body: {'token': user.jwt, 'firebaseToken': token},
        ).timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
        preferences.setString(Constants.firebaseKey, token);
      }
    });
  }

  void onTokenRefresh(User user) {
    messaging.onTokenRefresh.listen((token) async {
      String prevToken = preferences.getString(Constants.firebaseKey);
      if (prevToken != null) {
        await client.post(
          Uri.parse(Constants.urls['removeFirebaseToken']),
          body: {'token': user.jwt, 'firebaseToken': prevToken},
        ).timeout(
          Duration(seconds: Constants.timeoutSecond),
          onTimeout: () => http.Response('Error', 500),
        );
      }
      await client.post(
        Uri.parse(Constants.urls['registerFirebaseToken']),
        body: {'token': user.jwt, 'firebaseToken': token},
      ).timeout(
        Duration(seconds: Constants.timeoutSecond),
        onTimeout: () => http.Response('Error', 500),
      );
      preferences.setString(Constants.firebaseKey, token);
    });
  }

  void firebaseConfig(User user) async {
    // Initialize app
    await initialApp();
    messaging = FirebaseMessaging.instance;
    // Setup for foreground notification
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // Permission
    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    // Token handler
    getToken(user);
    // On Token Refresh Listener
    onTokenRefresh(user);
  }

  void attachMessageOpenAppListener() async {
    await initialApp();
    // Listener for arriving message event
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Opended app receiving message");
    });
    // On open app from message when app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background app receiving message");
    });
    // On open app from message when app is in terminated state
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Terminated app receiving message");
    }
  }
}
