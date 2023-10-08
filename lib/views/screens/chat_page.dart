import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/controller/msg_controller.dart';
import 'package:firebase_chat_app/controller/status_controller.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:firebase_chat_app/helpers/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../modals/chat_modal.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  Map data = Get.arguments;

  MsgController msgController = Get.put(MsgController());
  StatusController statusController = Get.put(StatusController());

  TextEditingController chatController = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print("==========STATUS Check Start==========");
    print("Status State: $state");

    switch (state) {
      case AppLifecycleState.paused:
        statusController.checkStatus(
            email: data['sender'], currentStatus: "Offline");
        FireStoreHelper.fireStoreHelper.userOffline(email: data['sender']);
        break;
      case AppLifecycleState.resumed:
        statusController.checkStatus(
            email: data['sender'], currentStatus: "Online");
        FireStoreHelper.fireStoreHelper.userOnline(email: data['sender']);
        break;
      default:
        statusController.checkStatus(
            email: data['sender'], currentStatus: "Offline");
        FireStoreHelper.fireStoreHelper.userOffline(email: data['sender']);
    }

    print("==========STATUS Check End==========");
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FireStoreHelper.fireStoreHelper
                  .getUserStream(userEmailId: data['receiver']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Text(userData['name']);
                } else {
                  return const Text("User");
                }
              },
            ),
            StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getUserStream(
                  userEmailId: data['receiver'],
                ),
                builder: (context, snapShot) {
                  DocumentSnapshot<Map<String, dynamic>>? doc = snapShot.data;
                  Map<String, dynamic>? userData = doc!.data();

                  print(userData!['status']);
                  return Text(
                    userData['status'] == "Online" ? "Online" : "Offline",
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  );
                }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper
                    .getUserStream(userEmailId: data['sender']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    var sentChat =
                        userData['sent']['${data['receiver']}']['msg'];
                    var sentTime =
                        userData['sent']['${data['receiver']}']['time'];

                    var receivedChat =
                        userData['received']['${data['receiver']}']['msg'];
                    var receivedTime =
                        userData['received']['${data['receiver']}']['time'];

                    List sTimes = sentTime.map((e) {
                      List<String> data = e.split('-');

                      var date = data[0].split('/');
                      var time = data[1].split(':');

                      DateTime dateTime = DateTime(
                        int.parse(date[2]),
                        int.parse(date[1]),
                        int.parse(date[0]),
                        int.parse(time[0]),
                        int.parse(time[1]),
                      );

                      return dateTime;
                    }).toList();

                    List rTimes = receivedTime.map((e) {
                      List<String> data = e.split('-');

                      var date = data[0].split('/');
                      var time = data[1].split(':');

                      DateTime dateTime = DateTime(
                        int.parse(date[2]),
                        int.parse(date[1]),
                        int.parse(date[0]),
                        int.parse(time[0]),
                        int.parse(time[1]),
                      );

                      return dateTime;
                    }).toList();

                    print("SENDER CHAT: $sentChat");
                    print("SENDER TIME: $sentTime");

                    List<ChatModal> allChats =
                        List.generate(sentChat.length, (index) {
                      return ChatModal(sentChat[index], sTimes[index], "sent");
                    });

                    allChats.addAll(
                      List.generate(receivedChat.length, (index) {
                        return ChatModal(
                            receivedChat[index], rTimes[index], "received");
                      }),
                    );

                    allChats.sort((c1, c2) => c1.time.isAfter(c2.time) ? 1 : 0);

                    allChats.forEach((element) {
                      print("TIME: ${element.time.minute}");
                    });

                    return ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onLongPress: () {
                          msgController.editMode(false);

                          if (allChats[index].type == 'sent') {
                            showDialog(
                              context: context,
                              builder: (context) => Obx(() {
                                return AlertDialog(
                                  title: const Text("Message Info"),
                                  content: Visibility(
                                    visible: msgController.editMode.value,
                                    child: TextFormField(
                                      initialValue: allChats[index].chat,
                                      onChanged: (val) {
                                        editController.text = val;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        msgController.canEdit();
                                      },
                                      icon: Icon(
                                        msgController.editMode.value
                                            ? Icons.cancel
                                            : Icons.edit,
                                      ),
                                      label: Text(
                                        msgController.editMode.value
                                            ? "Cancel"
                                            : "Edit",
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        int sentChatIndex = sentChat
                                            .indexOf(allChats[index].chat);
                                        int receivedChatIndex = receivedChat
                                            .indexOf(allChats[index].chat);

                                        if (msgController.editMode.value) {
                                          FireStoreHelper.fireStoreHelper
                                              .editChat(
                                            senderEmailId: data['sender'],
                                            receiverEmailId: data['receiver'],
                                            chatIndex: sentChatIndex,
                                            newMsg: editController.text,
                                          );
                                        } else {
                                          FireStoreHelper.fireStoreHelper
                                              .deleteChat(
                                            senderEmailId: data['sender'],
                                            receiverEmailId: data['receiver'],
                                            chatIndex: sentChatIndex,
                                          );
                                        }

                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        msgController.editMode.value
                                            ? Icons.done
                                            : Icons.delete,
                                      ),
                                      label: Text(
                                        msgController.editMode.value
                                            ? "Update"
                                            : "Delete",
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: allChats[index].type == 'sent'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: allChats[index].type == 'sent'
                                    ? Colors.indigoAccent.shade100
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.only(
                                  topLeft: allChats[index].type == 'sent'
                                      ? const Radius.circular(8)
                                      : Radius.zero,
                                  bottomLeft: const Radius.circular(8),
                                  bottomRight: const Radius.circular(8),
                                  topRight: allChats[index].type == 'sent'
                                      ? Radius.zero
                                      : const Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    allChats[index].chat,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "${allChats[index].time.hour}:${allChats[index].time.minute}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
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
            TextField(
              keyboardType: TextInputType.multiline,
              controller: chatController,
              textInputAction: TextInputAction.send,
              onSubmitted: (val) {
                print("MESSAGE : $val");

                FireStoreHelper.fireStoreHelper.sentChats(
                  senderEmailId: data['sender'],
                  receiverEmailId: data['receiver'],
                  msg: val,
                );

                NotificationHelper.notificationHelper.simpleNotification(
                  email: data['sender'],
                  msg: chatController.text,
                );

                chatController.clear();
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    FireStoreHelper.fireStoreHelper.sentChats(
                      senderEmailId: data['sender'],
                      receiverEmailId: data['receiver'],
                      msg: chatController.text,
                    );

                    NotificationHelper.notificationHelper.simpleNotification(
                      email: data['sender'],
                      msg: chatController.text,
                    );

                    chatController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                label: const Text("Message"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
