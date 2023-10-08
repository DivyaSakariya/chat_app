import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/modals/person_modal.dart';
import 'package:firebase_chat_app/modals/student_modal.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final String _collectionUser = 'User';
  final String _collectionAllUser = 'All User';

  final String _userEmailId = 'emailId';
  final String _userName = 'name';
  final String _userPassword = 'password';
  final String _userContacts = 'contacts';
  final String _userReceived = 'received';
  final String _userSent = 'sent';
  final String _userStatus = 'status';

  addUser({required PersonModal personModal}) {
    Map<String, dynamic> data = {
      _userEmailId: personModal.emailId,
      _userName: personModal.name,
      _userPassword: personModal.password,
      _userContacts: personModal.contacts,
      _userReceived: personModal.received,
      _userSent: personModal.sent,
      _userStatus: personModal.status,
    };

    _firebaseFirestore
        .collection(_collectionUser)
        .doc(personModal.emailId)
        .set(data);
  }

  getCredentialPsw({required String emailId}) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection(_collectionUser).doc(emailId).get();

    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;

    return userData['password'];
  }

  getCredentialEmail({required String emailId}) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection(_collectionUser).doc(emailId).get();

    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;

    return userData['emailId'];
  }

  Future<Map<String, dynamic>> getAllUserEmail() async {
    DocumentSnapshot docs = await _firebaseFirestore
        .collection(_collectionAllUser)
        .doc('email')
        .get();

    print("-----------------");
    print(docs.data);
    print("-----------------");

    return docs.data as Future<Map<String, dynamic>>;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAllUserEmailStream() {
    return _firebaseFirestore
        .collection(_collectionAllUser)
        .doc('email')
        .snapshots();
  }

  addContacts({required String emailId, required String contactEmail}) async {
    Map<String, dynamic> user = await getUser(emailId: emailId);

    user['contacts'].add(contactEmail);

    Map<String, dynamic> data = {
      contactEmail: {
        'msg': [],
        'time': [],
      },
    };

    _firebaseFirestore.collection(_collectionUser).doc(emailId).set(user);
  }

  addUserEmail() async {}

  Future<Map<String, dynamic>> getUser({required String emailId}) async {
    DocumentSnapshot docs =
        await _firebaseFirestore.collection(_collectionUser).doc(emailId).get();

    return docs.data() as Map<String, dynamic>;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
      {required String userEmailId}) {
    return _firebaseFirestore
        .collection(_collectionUser)
        .doc(userEmailId)
        .snapshots();
  }

  getChats(
      {required String senderEmailId, required String receiverEmailId}) async {
    Map sender = await getUser(emailId: senderEmailId);

    Map senderChat = sender['sent'][receiverEmailId];
    Map receiverChat = sender['received'][receiverEmailId];

    Map chats = {
      'sent': senderChat,
      'received': receiverChat,
    };

    return chats;
  }

  sentChats(
      {required String senderEmailId,
      required String receiverEmailId,
      required String msg}) async {
    Map<String, dynamic> sender = await getUser(emailId: senderEmailId);
    Map<String, dynamic> receiver = await getUser(emailId: receiverEmailId);

    DateTime d = DateTime.now();

    String time = "${d.day}/${d.month}/${d.year}-${d.hour}:${d.minute}";

    print("-----------------------------------");
    print("TIME: $time");
    print("SENDER: $sender");
    print("RECEIVER: $receiver");
    print("-----------------------------------");

    sender['sent'][receiverEmailId]['msg'].add(msg);
    sender['sent'][receiverEmailId]['time'].add(time);

    receiver['received'][senderEmailId]['msg'].add(msg);
    receiver['received'][senderEmailId]['time'].add(time);

    print("-----------NEW DATA----------------");
    print("TIME: $time");
    print("SENDER: $sender");
    print("RECEIVER: $receiver");
    print("-----------------------------------");

    _firebaseFirestore
        .collection(_collectionUser)
        .doc(senderEmailId)
        .set(sender);
    _firebaseFirestore
        .collection(_collectionUser)
        .doc(receiverEmailId)
        .set(receiver);
  }

  editChat(
      {required String senderEmailId,
      required String receiverEmailId,
      required int chatIndex,
      required String newMsg}) async {
    Map<String, dynamic> sender = await getUser(emailId: senderEmailId);
    Map<String, dynamic> receiver = await getUser(emailId: receiverEmailId);

    sender['sent'][receiverEmailId]['msg'][chatIndex] = newMsg;
    receiver['received'][senderEmailId]['msg'][chatIndex] = newMsg;

    _firebaseFirestore
        .collection(_collectionUser)
        .doc(senderEmailId)
        .set(sender);
    _firebaseFirestore
        .collection(_collectionUser)
        .doc(receiverEmailId)
        .set(receiver);
  }

  deleteChat({
    required String senderEmailId,
    required String receiverEmailId,
    required int chatIndex,
  }) async {
    Map<String, dynamic> sender = await getUser(emailId: senderEmailId);
    Map<String, dynamic> receiver = await getUser(emailId: receiverEmailId);

    sender['sent'][receiverEmailId]['msg'].removeAt(chatIndex);
    sender['sent'][receiverEmailId]['time'].removeAt(chatIndex);

    receiver['received'][senderEmailId]['msg'].removeAt(chatIndex);
    receiver['received'][senderEmailId]['time'].removeAt(chatIndex);

    _firebaseFirestore
        .collection(_collectionUser)
        .doc(senderEmailId)
        .set(sender);
    _firebaseFirestore
        .collection(_collectionUser)
        .doc(receiverEmailId)
        .set(receiver);
  }

  userOffline({required String email}) async {
    Map<String, dynamic>? data = await getUser(emailId: email);
    data['status'] = "Offline";

    _firebaseFirestore.collection(_collectionUser).doc(email).set(data);

    print(data.toString());
  }

  userOnline({required String email}) async {
    Map<String, dynamic>? data = await getUser(emailId: email);
    data['status'] = "Online";

    _firebaseFirestore.collection(_collectionUser).doc(email).set(data);
  }
}
