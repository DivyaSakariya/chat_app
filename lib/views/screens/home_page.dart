import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:firebase_chat_app/helpers/notification_helper.dart';
import 'package:firebase_chat_app/utils/route_utils.dart';
import 'package:flutter/material.dart';
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

    // FireStoreHelper.fireStoreHelper.getContacts(emailId: user!.email);

    print("EMAIL ${user!.email}");

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
              accountName: Text(user.userName),
              accountEmail: Text(user.email),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper
            .getUserStream(userEmailId: user.email),
        builder: (context, snap) {
          if (snap.hasData) {
            DocumentSnapshot<Map<String, dynamic>> allData = snap.data!;
            Map<String, dynamic>? data = allData.data();
            List contacts = data!['contacts'];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
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
                  }),
            );
          } else if (snap.hasError) {
            return Center(
              child: Text(
                snap.error.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(18),
      //   child: FutureBuilder(
      //     future:
      //         FireStoreHelper.fireStoreHelper.getContacts(emailId: user.email),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return ListView.builder(
      //           itemCount: snapshot.data!.length,
      //           itemBuilder: (context, index) => Card(
      //             child: ListTile(
      //               onLongPress: () {
      //                 print("==========Notification==========");
      //
      //                 LocalNotificationHelper.localNotificationHelper
      //                     .simpleNotification(
      //                   userEmailId: user.email,
      //                   title: "User: ${user.userName}",
      //                   subtitle: "SEND TO ${snapshot.data![index]}",
      //                 );
      //               },
      //               onTap: () {
      //                 Map data = {
      //                   'sender': user.email,
      //                   'receiver': snapshot.data![index],
      //                 };
      //
      //                 Get.toNamed('/chat_page', arguments: data);
      //               },
      //               title: Text(snapshot.data![index]),
      //             ),
      //           ),
      //         );
      //       } else if (snapshot.hasError) {
      //         return Center(
      //           child: Text(snapshot.error.toString()),
      //         );
      //       } else {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     },
      //   ),
      // ),
    );
  }
}

// StreamBuilder(
//   stream: FireStoreHelper.fireStoreHelper
//       .getUserStream(userEmailId: user.email),
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       DocumentSnapshot<Map<String, dynamic>> allData = snapshot.data!;
//       Map<String, dynamic>? data = allData.data();
//       List contacts = data!['contacts'];
//
//       return ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (context, index) => Card(
//           child: ListTile(
//             onLongPress: () {
//               print("==========Notification==========");
//
//               LocalNotificationHelper.localNotificationHelper
//                   .simpleNotification(
//                 userEmailId: user.email,
//                 title: "User: ${user.userName}",
//                 subtitle: "SEND TO ${snapshot.data![index]}",
//               );
//             },
//             onTap: () {
//               Map data = {
//                 'sender': user.email,
//                 'receiver': snapshot.data![index],
//               };
//
//               Get.toNamed('/chat_page', arguments: data);
//             },
//             title: Text(snapshot.data![index]),
//           ),
//         ),
//       );
//     } else if (snapshot.hasError) {
//       return Center(
//         child: Text(snapshot.error.toString()),
//       );
//     } else {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//   },
// ),
