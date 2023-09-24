import 'dart:developer';

import 'package:firebase_chat_app/controller/msg_controller.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../modals/chat_modal.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  Map data = Get.arguments;

  MsgController msgController = Get.put(MsgController());

  TextEditingController chatController = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
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

                    log("SENDER CHAT: $sentChat");
                    log("SENDER TIME: $sentTime");

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
                      log("TIME: ${element.time.minute}");
                    });

                    return ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (context, index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: allChats[index].type == 'sent'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Card(
                                  child: ListTile(
                                    onLongPress: () {
                                      if (allChats[index].type == 'sent') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Obx(() {
                                            return AlertDialog(
                                              title: const Text("Message Info"),
                                              content: Visibility(
                                                visible: msgController
                                                    .editMode.value,
                                                child: TextFormField(
                                                  initialValue:
                                                      allChats[index].chat,
                                                  onChanged: (val) {
                                                    editController.text = val;
                                                  },
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    msgController.isEdit();
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
                                                        .indexOf(allChats[index]
                                                            .chat);
                                                    int receivedChatIndex =
                                                        receivedChat.indexOf(
                                                            allChats[index]
                                                                .chat);

                                                    if (msgController
                                                        .editMode.value) {
                                                      FireStoreHelper
                                                          .fireStoreHelper
                                                          .editChat(
                                                        senderEmailId:
                                                            data['sender'],
                                                        receiverEmailId:
                                                            data['receiver'],
                                                        senderChatIndex:
                                                            sentChatIndex,
                                                        receiverChatIndex:
                                                            receivedChatIndex,
                                                        newMsg:
                                                            editController.text,
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
                                    title: Text(allChats[index].chat),
                                    subtitle: Text(
                                        "${allChats[index].time.hour}:${allChats[index].time.minute}"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            TextField(
              controller: chatController,
              textInputAction: TextInputAction.send,
              onSubmitted: (val) {
                log("MESSAGE : $val");

                FireStoreHelper.fireStoreHelper.sentChats(
                  senderEmailId: data['sender'],
                  receiverEmailId: data['receiver'],
                  msg: val,
                );
                chatController.clear();
              },
              decoration: InputDecoration(
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
