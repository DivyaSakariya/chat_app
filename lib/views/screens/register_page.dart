import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../modals/user_modal.dart';
import '../../utils/route_utils.dart';
import '../components/my_submit_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
              child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(100),
                  const Icon(
                    Icons.message_rounded,
                    size: 100,
                  ),
                  const Gap(50),
                  const Text(
                    "Let's create an account for you!!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(25),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const Gap(10),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const Gap(10),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const Gap(25),
                  MySubmitButton(
                    onTap: () {
                      if (passwordController != confirmPasswordController) {
                        Get.snackbar(
                          "Failed!!",
                          "Password do not match!",
                          colorText: Colors.red,
                        );
                      }

                      try {
                        AuthHelper.authHelper.signUpWithUserEmailPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          name: userNameController.text,
                        );

                        Get.snackbar(
                          "Success!!",
                          "Sign Up done...",
                          colorText: Colors.green,
                        );
                        UserModal userModal = UserModal();

                        userModal.userName = userNameController.text;
                        userModal.email = emailController.text;

                        Get.offNamed(MyRoutes.homePage, arguments: userModal);
                      } catch (e) {
                        Get.snackbar(
                          "Failed!!",
                          e.toString(),
                          colorText: Colors.red,
                        );
                      }
                    },
                    text: "Sign Up",
                  ),
                  const Gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member?"),
                      const Gap(4),
                      GestureDetector(
                        onTap: onTap,
                        child: const Text(
                          "LogIn now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
