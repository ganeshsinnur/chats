import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intellichat/models/chat_user.dart';
import 'package:intellichat/models/message.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for cloud firestore storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });}

  //for checking whether user exist ir no
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }



  //for checking whether user exist ir no
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "hello",
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: user.uid,
        email: user.email.toString(),
        pushToken: "");
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  //for getting all users
  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type,String rMsg,String rId) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type,rMsg,rId));
    log("$firestore.collection('users').doc(chatUser.id).collection('my_users').doc(user.uid).set({}).then((value)");
  }


  //for updating user info
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //for updating profile photo
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storing file with extension
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data transfered: ${p0.bytesTransferred / (1024 * 1024)}Mb');
    });

    //updating image in database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /******************* Chat Screen Related APIs *******************/

  //useful for getting convseration id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMesseages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessage(
      ChatUser Chatuser, String msg,Type type,String rMsg,String rId) async {
    // msg sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    log("fromId --> $user.uid");
    log("Conv id-->${getConversationID(Chatuser.id)}");
    log("timeStamp--> $time");

    //message to send
    final Message message = Message(
        rMsg: rMsg,
        msg: msg,
        read: '',
        told: Chatuser.id,
        type: type,
        fromId: user.uid,
        rId: rId,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(Chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update msg read status
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }


  //get onlu last msg
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file,String rMsg,String rId) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storing file with extension
    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data transfered: ${p0.bytesTransferred / (1024 * 1024)}Mb');
    });

    //updating image in database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image,rMsg,rId);
  }

  //delete message
  static Future<void> getMessageInfo(Message message) async {
    log("${firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)}");
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)
        .delete();
    log("${firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)}");

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }


  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }


  ///Things for smart Reply generation
  static Future<List<String>> fetchSmartReplies(List<String> messages) async {
    // Here, you would call your smart reply API
    // This is a dummy implementation
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return ["Sure!", "No, thanks.", "I'll think about it."];
  }

}
