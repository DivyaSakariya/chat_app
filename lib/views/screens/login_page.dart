import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:firebase_chat_app/modals/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    String? email;
    String? password;
    bool isNav = false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     bool isSignIn =
              //         await AuthHelper.authHelper.signInAnonymously();
              //
              //     if (isSignIn) {
              //       Get.offNamed('/home_page');
              //     }
              //   },
              //   child: const Text("Anonymously SignIn"),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await AuthHelper.authHelper.registerUser(
              //       email: 'abc14@mail.yahoo',
              //       password: 'Abc0314@Demo',
              //     );
              //   },
              //   child: const Text("Register"),
              // ),

              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: userNameController,
                      onFieldSubmitted: (val) async {
                        email = await FireStoreHelper.fireStoreHelper
                            .getCredential(emailId: val);

                        password = await FireStoreHelper.fireStoreHelper
                            .getCredential(emailId: val);

                        print("EMAIL: $email");
                        print("PSW: $password");
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "User Name",
                      ),
                    ),
                    const Gap(12),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (val) {
                        if (email == val) {
                          isNav = true;
                          // Get.snackbar(
                          //   "Success!!",
                          //   "LogIn Done...",
                          //   colorText: Colors.green,
                          //   snackPosition: SnackPosition.BOTTOM,
                          // );
                        } else {
                          isNav = false;
                          // Get.snackbar(
                          //   "Failed!!",
                          //   "Email Id Mismatched...",
                          //   colorText: Colors.red,
                          //   snackPosition: SnackPosition.BOTTOM,
                          // );
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                    const Gap(12),
                    TextFormField(
                      onFieldSubmitted: (val) {
                        if (password == val) {
                          isNav = true;
                          // Get.snackbar(
                          //   "Success!!",
                          //   "printIn Done...",
                          //   colorText: Colors.green,
                          //   snackPosition: SnackPosition.BOTTOM,
                          // );
                        } else {
                          isNav = false;
                          // Get.snackbar(
                          //   "Failed!!",
                          //   "Password Mismatched...",
                          //   colorText: Colors.red,
                          //   snackPosition: SnackPosition.BOTTOM,
                          // );
                        }
                      },
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                    ),
                    const Gap(18),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  bool isSignIn =
                      await AuthHelper.authHelper.signInWithUserEmailPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  UserModal userModal = UserModal();

                  userModal.userName = userNameController.text;
                  userModal.email = emailController.text;

                  print("NAME: ${userModal.userName}");
                  print("EMAIL: ${userModal.email}");

                  if (isNav) {
                    Get.offNamed('/home_page', arguments: userModal);
                  } else {
                    print("FAILED TO LogIN...");
                    Get.offNamed('/home_page', arguments: userModal);
                    Get.snackbar(
                      "Failed!!",
                      "Please Check Email Id or Password...",
                      colorText: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text("SignIn"),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     GoogleSignInAccount? googleAccount =
              //         await AuthHelper.authHelper.googleSignIn();
              //
              //     if (googleAccount != null) {
              //       UserModal userModal = UserModal();
              //
              //       userModal.userName = googleAccount.displayName;
              //       userModal.email = googleAccount.email;
              //       userModal.image = googleAccount.photoUrl;
              //
              //       Get.offNamed(
              //         '/home_page',
              //         arguments: userModal,
              //       );
              //     }
              //   },
              //   child: const Text("SignIn with Google"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
