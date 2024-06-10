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

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _handleGooglebtnClick() {
    Dailogs.showProgressbar(context); // For showing progress bar
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dailogs.showSnackbar(context, "Check Internet connection and Try again!");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .18,
            left: mq.width * .15,
            //width: mq.width * .9,
            //height: mq.height * .07,
            child:  const Column(
              children: [
                Text(
                  "I N T E L L I  C H A T",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily:'Sedan',
                    fontSize: 28,
                    color: Color(0xFFF4F4F4),
                    fontWeight: FontWeight.bold,
                    letterSpacing: .7,
                    //fontStyle: ,
                  ),
                ),
                // Text(
                //   "Please Login To Your Account",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: Color(0xFF7B7B7B),
                //     fontWeight: FontWeight.bold,
                //     letterSpacing: .7,
                //     //fontStyle: ,
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleGooglebtnClick();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDCD7CF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)
              ),
              icon: Image.asset('assets/images/google.png', height: mq.height * .03),
              label: const Text('Sign in with Google',style: TextStyle(color:Colors.black87),),
            ),
          ),
        ],
      ),
    );
  }
}