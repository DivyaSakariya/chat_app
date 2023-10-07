import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  NotificationHelper._();

  static final NotificationHelper notificationHelper = NotificationHelper._();

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

  simpleNotification({required String email, required String msg}) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      email,
      msg,
      importance: Importance.high,
      priority: Priority.high,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      subtitle: email,
    );
    flutterLocalNotificationsPlugin
        .show(
      101,
      email,
      msg,
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
