import 'dart:developer';

import 'package:firebase_chat_app/helpers/auth_helper.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modals/user_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal? user = Get.arguments;

    FireStoreHelper.fireStoreHelper.getContacts(emailId: user!.email);

    log("EMAIL ${user.email}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("We Chat"),
        actions: [
          IconButton(
            onPressed: () {
              AuthHelper.authHelper.signOut();
              Get.offNamed('/');
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
              accountName: Text(user.userName ?? 'hbedef'),
              accountEmail: Text(user.email ?? 'abc@gmail.com'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: FutureBuilder(
          future:
              FireStoreHelper.fireStoreHelper.getContacts(emailId: user.email),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () {
                      Map data = {
                        'sender': user.email,
                        'receiver': snapshot.data![index],
                      };

                      Get.toNamed('/chat_page', arguments: data);
                    },
                    title: Text(snapshot.data![index]),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        // StreamBuilder(
        //   stream: FireStoreHelper.fireStoreHelper.getStudentStream(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        //           snapshot.data!.docs;
        //
        //       List<StudentModal> allStudents = docs
        //           .map((e) => StudentModal.fromMap(data: e.data()))
        //           .toList();
        //
        //       return ListView.builder(
        //         itemCount: allStudents.length,
        //         itemBuilder: (context, index) => ListTile(
        //           title: Text(allStudents[index].name),
        //           subtitle: Text(allStudents[index].age.toString()),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('add_student_page');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
