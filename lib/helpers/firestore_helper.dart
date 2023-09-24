import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/modals/student_modal.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final String _collectionStudent = 'Student';

  final String _collectionUser = 'User';

  final String _colId = 'id';
  final String _colName = 'name';
  final String _colAge = 'age';
  final String _colCourse = 'course';

  final String _userEmailId = 'emailId';
  final String _userName = 'name';
  final String _userPassword = 'password';
  final String _userContacts = 'contacts';
  final String _userReceived = 'received';
  final String _userSent = 'sent';

  final int _counter = 0;

  getCredential({required String emailId}) async {
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection(_collectionUser).doc(emailId).get();

    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;

    return userData['password'];
  }

  Future<Map<String, dynamic>> getUser({required String emailId}) async {
    // return firebaseFirestore
    //     .collection(_collectionUser)
    //     .doc(emailId)
    //     .snapshots();

    DocumentSnapshot docs =
        await _firebaseFirestore.collection(_collectionUser).doc(emailId).get();

    return docs.data() as Map<String, dynamic>;
  }

  Future<List> getContacts({required String emailId}) async {
    Map<String, dynamic> user = await getUser(emailId: emailId);

    log("User Contact Data: $user['contacts");

    return user['contacts'];
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

    log("-----------------------------------");
    log("TIME: $time");
    log("SENDER: $sender");
    log("RECEIVER: $receiver");
    log("-----------------------------------");

    sender['sent'][receiverEmailId]['msg'].add(msg);
    sender['sent'][receiverEmailId]['time'].add(time);

    receiver['received'][senderEmailId]['msg'].add(msg);
    receiver['received'][senderEmailId]['time'].add(time);

    log("-----------NEW DATA----------------");
    log("TIME: $time");
    log("SENDER: $sender");
    log("RECEIVER: $receiver");
    log("-----------------------------------");

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
      required int senderChatIndex,
      required int receiverChatIndex,
      required String newMsg}) async {
    Map<String, dynamic> sender = await getUser(emailId: senderEmailId);
    Map<String, dynamic> receiver = await getUser(emailId: receiverEmailId);

    sender['sent'][receiverEmailId]['msg'][senderChatIndex] = newMsg;
    receiver['received'][senderEmailId]['msg'][receiverChatIndex] = newMsg;

    _firebaseFirestore
        .collection(_collectionUser)
        .doc(senderEmailId)
        .set(sender);
    _firebaseFirestore
        .collection(_collectionUser)
        .doc(receiverEmailId)
        .set(receiver);
  }

  addStudent({required StudentModal studentModal}) {
    Map<String, dynamic> data = {
      _colId: studentModal.id,
      _colName: studentModal.name,
      _colAge: studentModal.age,
      _colCourse: studentModal.course,
    };

    _firebaseFirestore
        .collection(_collectionStudent)
        .doc(studentModal.id.toString())
        .set(data);
  }

  Future<List<StudentModal>> getAllStudents() async {
    QuerySnapshot data =
        await _firebaseFirestore.collection(_collectionStudent).get();

    List<QueryDocumentSnapshot> allData = data.docs;

    List<StudentModal> allStudents = allData
        .map((e) => StudentModal.fromMap(data: e.data() as Map))
        .toList();

    log("Student Data: ${allStudents[0].id} ${allStudents[0].name}");

    return allStudents;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudentStream() {
    return _firebaseFirestore.collection(_collectionStudent).snapshots();
  }

  Future<int> getCounter() async {
    QuerySnapshot data =
        await _firebaseFirestore.collection(_counter as String).get();

    List<QueryDocumentSnapshot> doc = data.docs;

    Map<String, dynamic> count = doc[0].data() as Map<String, dynamic>;

    int idCount = count['val'];

    return idCount;
  }

  increaseId() async {
    int id = await getCounter();

    Map<String, dynamic> data = {
      'val': ++id,
    };

    _firebaseFirestore.collection(_counter as String).doc('count').set(data);
  }
}
