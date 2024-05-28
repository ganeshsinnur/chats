import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intellichat/models/chat_user.dart';

class APIs{
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  //for checking whether user exist ir no
  static  Future<bool> userExists() async{
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .get()
    ).exists;
  }

  //for creating a new user
  static  Future<void> createUser() async{
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
        pushToken: ""
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson()
    );
  }
}