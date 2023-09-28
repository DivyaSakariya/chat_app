import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotification() {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  simpleNotification(
      {required String userEmailId,
      required String title,
      required String subtitle}) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      userEmailId,
      "Hello",
      importance: Importance.high,
      priority: Priority.high,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      subtitle: subtitle,
    );

    flutterLocalNotificationsPlugin
        .show(
      userEmailId as int,
      title,
      subtitle,
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      ),
    )
        .then((value) {
      print("=====NOTIFICATION DISPLAYED======");
    }).catchError((error) {
      print("+++++ERROR: $error++++++");
    });
  }
}
