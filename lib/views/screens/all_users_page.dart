import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal? user = Get.arguments;

    FireStoreHelper.fireStoreHelper.getAllUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Users"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getAllUserEmailStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>> allData = snapshot.data!;
              Map<String, dynamic>? data = allData.data();
              List email = data!['email'];

              return ListView.builder(
                  itemCount: email.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          email[index],
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            await FireStoreHelper.fireStoreHelper.addContacts(
                              emailId: user!.email,
                              contactEmail: email[index],
                            );
                          },
                          child: const Text("Invite+"),
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
    );
  }
}
