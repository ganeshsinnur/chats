import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intellichat/helper/dailogs.dart';

import '../api/apis.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  //final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  @override

  _handleGooglebtnClick(){
    Dailogs.showProgressbar(context); //for showing progress Bar
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if(user != null){
        log('\nUsers: ${user.user}');
        log('\nUserAdditionalInfo : ${user.additionalUserInfo}');

        if(await APIs.userExists()){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomeScreen()));
        }else{
          await APIs.createUser().then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomeScreen()));
          });
        }


      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
  try{
    await InternetAddress.lookup('google.com');
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);
  }catch(e){
    log('\n_signInWithGoogle: $e');
    Dailogs.showSnackbar(context, "Check Internet connection and Try again!");
    return null;
  }
  }

  //sign out function
  // _signOut() async{
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }

  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Intelli Chat"),
        ),

        body: Stack(children: [
          Positioned(
              top: mq.height * .15,
              width: mq.width*.5,
              left: mq.width*.25,
              child: Image.asset('assets/images/monster.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width*.05,
              width: mq.width*.9,
              height:mq.height*.07,
              child:  ElevatedButton.icon(onPressed: (){
                _handleGooglebtnClick();
              },
                  icon: Image.asset('assets/images/google.png', height: mq.height * .03),
                  label: const Text('Sign in with Google')
              )
          ),
          Positioned(

              top: mq.height * .40,
              width: mq.width*.5,
              left: mq.width*.25,
              child: const Text("Intelli Chat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              color: Colors.green,
              fontWeight: FontWeight.bold,
              letterSpacing: .7, ),
          ))
        ],)
    );
  }

}

