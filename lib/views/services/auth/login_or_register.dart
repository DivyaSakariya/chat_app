import 'package:firebase_chat_app/views/screens/login_page.dart';
import 'package:firebase_chat_app/views/screens/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = false;

  changePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogInPage(onTap: changePage);
    } else {
      return RegisterPage(onTap: changePage);
    }
  }
}
