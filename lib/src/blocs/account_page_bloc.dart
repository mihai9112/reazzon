import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reazzon/src/blocs/bloc_provider.dart';

class AccountPageBloc extends BlocBase {
  String loggedUserId;

  AccountPageBloc({this.loggedUserId});

  void registerNotification(String currentUserId) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    _firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection('Users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      print('Error $err');
    });
  }

  void showNotification(message) async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings);

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.reazzon' : 'com.example.reazzon',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    try {
      await FlutterLocalNotificationsPlugin().show(
          0,
          message['title'].toString(),
          message['body'].toString(),
          platformChannelSpecifics,
          payload: json.encode(message));
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {}
}
