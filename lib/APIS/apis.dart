import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connect/models/ChatUser.dart';
import 'package:connect/models/message.dart';

import '../models/usermodel.dart';


class API {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static late ChatUser me;

  static FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");


  //for checking if user exists
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  //get self info
  static Future<void> getselfinfo() async {
    return await firestore
        .collection('Users')
        .doc(user.uid)
        .get()
        .then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }

  //get self infor for profile
  Future<Usermodel> getUser({String? UID}) async {
    try {
      final USER = await firestore
          .collection('Users')
          .doc(UID != null ? UID : user.uid)
          .get();
      final snapuser = USER.data()!;
      return Usermodel(
        snapuser['email'],
        snapuser['image'],
        snapuser['username'],
      );
    } on FirebaseException catch (e) {
      throw (e.message.toString());
    }
  }

  //for creating a new user
  static Future<void> createUser(String name, String mail, String interest,
      String status,) async {
    final chatUser = ChatUser(
      id: user.uid,
      username: name,
      email: user.email.toString(),
      interest: interest,
      image: user.photoURL.toString(),
      status: status,
      group: [],
    );

    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getmyUsersId() {
    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallusers() {
    return firestore
        .collection('Users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getmyusers(
      List<String> userIds) {
    if (userIds.isNotEmpty) {
      return firestore
          .collection('Users')
          .where('id', whereIn: userIds)
          .snapshots();
    } else {
      return firestore
          .collection('Users')
          .where('id', isEqualTo: 'dummy')
          .snapshots();
    }
  }

  //for updating user info
  static Future<void> updateuserinfo() async {
    await firestore.collection('Users').doc(user.uid).update({
      'username': me.username,
      'interest': me.interest,
      'status': me.status
    });
  }

  static updateprofilepicture(File file) async {
    final ext = file.path
        .split('.')
        .last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    me.image = await ref.getDownloadURL();

    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({
      'image': me.image,
    });
  }

  //getting conversation id
  static String getconversationid(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';


  //messeges
  static Stream<QuerySnapshot<Map<String, dynamic>>> getallmessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }


  static Future<void> sendMessage(ChatUser chatuser, String msg,
      Type type) async {
    //message sending time used as id
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final Message message = Message(toId: chatuser.id,
        msg: msg,
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore.collection(
        'chats/${getconversationid(chatuser.id)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> sendFirstmessage(ChatUser chatuser, String msg,
      Type type) async {
    await firestore
        .collection('Users')
        .doc(chatuser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatuser, msg, type));
    await firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatuser.id)
        .set({});
  }


  static Future<void> sendchatimage(ChatUser chatUser, File file) async {
    final ext = file.path
        .split('.')
        .last;
    final ref = storage.ref().child(
        'images/${getconversationid(chatUser.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    final imageUrl = await ref.getDownloadURL();

    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> deletemessage(Message message) async {
    await firestore
        .collection('chats/${getconversationid(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }


  static Future<bool> addChatUser(String name) async {
    final data = await firestore.collection('Users').where(
        'username', isEqualTo: name).get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      firestore
          .collection('Users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id).set({});
      return true;
    } else {
      return false;
    }
  }

  //return stream of users groups
  getmygroups() {
    return firestore
        .collection('Users')
        .doc(user.uid)
        .snapshots();
  }

  //creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${user.uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({
      'group': FieldValue.arrayUnion(
          ["${groupDocumentReference.id}_$groupName"])
    });
  }


  //getting the chats
  getChats(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  getGroupAdmin(String groupId) async {
    DocumentReference d = firestore.collection('groups').doc(groupId);
    DocumentSnapshot doc = await d.get();
    return doc['admin'];
  }

  //getting the group members
  getGroupMembers(String groupId) async {
    return firestore
        .collection('groups')
        .doc(groupId)
        .snapshots();
  }

  //search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //function->bool
  Future<bool> isUserJoined(String groupName, String groupId,
      String userName) async {
    DocumentReference userDocumentReference = firestore.collection('Users').doc(
        me.id);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['group'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(String groupId, String userName,
      String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = firestore.collection('Users').doc(
        me.id);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['group'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "group": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${user.uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "group": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${user.uid}_$userName"])
      });
    }
  }

  //send message
  sendGroupMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}

