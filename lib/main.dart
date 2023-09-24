import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/views/screens/add_student.dart';
import 'package:firebase_chat_app/views/screens/chat_page.dart';
import 'package:firebase_chat_app/views/screens/home_page.dart';
import 'package:firebase_chat_app/views/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          name: '/',
          page: () => LogInPage(),
        ),
        GetPage(
          name: '/home_page',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/add_student_page',
          page: () => AddStudent(),
        ),
        GetPage(
          name: '/chat_page',
          page: () => ChatPage(),
        ),
      ],
    );
  }
}
