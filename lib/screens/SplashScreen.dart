import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/screens/HomeScreen.dart';
import 'dart:async';

import '../api/apis.dart';
import 'LoginScreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  //final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>{


  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 1500),(){

      //exits from full screen
      //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      //seting color of statur bar

      //SystemChrome.setEnabledSystemUIMode(SystemUiOverlayStyle(statusBarColor: Colors.transparent) as SystemUiMode);
      if(APIs.auth.currentUser != null){
        log('\nUsers: ${APIs.auth.currentUser}');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
      }
      //navigate to Homecreen

    });
  }
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;

    return Scaffold(

        body: Stack(children: [
          Positioned(
              top: mq.height * .30,
              width: mq.width*.5,
              left: mq.width*.25,
              child: Image.asset('assets/images/monster.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width*.35,
              //width: mq.width*.9,
              height:mq.height*.07,
              child: const Text("Intelli Chat",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .7, ),
              )
          )
        ],)
    );
  }

}

