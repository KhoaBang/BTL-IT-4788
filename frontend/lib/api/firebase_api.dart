//setup firebase_api.dart
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> hadleBackgroundMessage(RemoteMessage message) async {
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('payload: ${message.data}');
}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'hello',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();
  void handlerMessage(RemoteMessage? message){
    if(message==null) return;
    print(message);
  }

  Future initLocalNotifications() async {
    // const ios = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        final payload = notificationResponse.payload;
        if (payload == null) return;
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        handlerMessage(message);
      },
    );


    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_androidChannel);
    }

  }
  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handlerMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlerMessage);
    FirebaseMessaging.onBackgroundMessage(hadleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message){
      final notification = message.notification;
      if(notification== null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(_androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher'
          )
        ),
        payload: jsonEncode(message.toMap()),
      );

    });
  }
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('token:$fCMToken');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fCMToken ?? '');
    initPushNotification();
    initLocalNotifications();
  }

}
