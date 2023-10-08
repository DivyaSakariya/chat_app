import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:firebase_chat_app/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../modals/user_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  askNotificationPermission() async {
    PermissionStatus permissionStatus = await Permission.notification.request();

    print("=====STATUS: ${permissionStatus.isGranted}");
  }

  @override
  Widget build(BuildContext context) {
    UserModal? user = Get.arguments;

    askNotificationPermission();

    return Scaffold(
      appBar: AppBar(
        title: const Text("We Chat"),
        actions: [
          IconButton(
            onPressed: () {
              AuthHelper.authHelper.signOut();
              Get.offNamed(MyRoutes.loginOrRegister);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              // currentAccountPicture: CircleAvatar(
              //   foregroundImage:
              //       user.image.isEmpty ? null : NetworkImage(user.image),
              // ),
              currentAccountPicture: const CircleAvatar(
                foregroundImage: NetworkImage(
                  "https://e1.pxfuel.com/desktop-wallpaper/454/79/desktop-wallpaper-wild-nature-for-whatsapp-dp-www-galleryneed-awesome-dp.jpg",
                ),
              ),
              accountName: Text(user!.userName),
              accountEmail: Text(user.email),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper
              .getUserStream(userEmailId: user.email),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>> allData = snapshot.data!;
              Map<String, dynamic>? data = allData.data();
              List contacts = data!['contacts'];

              return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          Map<String, dynamic>? recieved = await FireStoreHelper
                              .fireStoreHelper
                              .getUser(emailId: contacts[index]);
                          Map data = {
                            'sender': user.email,
                            'receiver': contacts[index],
                          };
                          Get.toNamed(MyRoutes.chatPage, arguments: data);
                        },
                        title: Text(
                          contacts[index],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SpinKitFadingCircle(),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(MyRoutes.allUsersPage, arguments: user);
        },
        child: const Icon(Icons.add_ic_call),
      ),
    );
  }
}
