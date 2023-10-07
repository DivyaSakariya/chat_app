import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/helpers/notification_helper.dart';
import 'package:firebase_chat_app/utils/route_utils.dart';
import 'package:firebase_chat_app/views/screens/add_student.dart';
import 'package:firebase_chat_app/views/screens/chat_page.dart';
import 'package:firebase_chat_app/views/screens/home_page.dart';
import 'package:firebase_chat_app/views/screens/login_page.dart';
import 'package:firebase_chat_app/views/services/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationHelper.notificationHelper.initNotification();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getUserLoggedIn();
  }

  getUserLoggedIn() {
    AuthHelper.authHelper.userIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: MyRoutes.loginOrRegister,
          page: () => const LoginOrRegister(),
        ),
        GetPage(
          name: MyRoutes.homePage,
          page: () => HomePage(),
        ),
        GetPage(
          name: MyRoutes.chatPage,
          page: () => ChatPage(),
        ),
      ],
    );
  }
}
