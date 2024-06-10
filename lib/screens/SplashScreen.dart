import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/screens/HomeScreen.dart';
import 'dart:async';

import '../api/apis.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500 ),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -270).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _sizeAnimation = Tween<double>(begin: 24, end: 32).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: Text(
                "I N T E L L I  C H A T",
                style: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: _sizeAnimation.value,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .7,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intellichat/screens/HomeScreen.dart';
// import 'dart:async';
//
// import '../api/apis.dart';
// import 'LoginScreen.dart';
//
//
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   //final String title;
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
// class _SplashScreenState extends State<SplashScreen>{
//
//
//   @override
//   void initState(){
//     super.initState();
//     Future.delayed(Duration(milliseconds: 1500),(){
//
//       //exits from full screen
//      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       //seting color of statur bar
//
//       //SystemChrome.setEnabledSystemUIMode(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.green,statusBarColor: Colors.green) as SystemUiMode );
//       if(APIs.auth.currentUser != null){
//         log('\nUsers: ${APIs.auth.currentUser}');
//
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//       }else{
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
//       }
//       //navigate to Homecreen
//
//     });
//   }
//   Widget build(BuildContext context) {
//     var mq=MediaQuery.of(context).size;
//
//     return Scaffold(
//
//         body: Stack(children: [
//           Positioned(
//               top: mq.height * .30,
//               width: mq.width*.5,
//               left: mq.width*.25,
//               child: Image.asset('assets/images/monster.png')),
//           Positioned(
//               bottom: mq.height * .15,
//               left: mq.width*.35,
//               //width: mq.width*.9,
//               height:mq.height*.07,
//               child: const Text("Intelli Chat",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 25,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: .7, ),
//               )
//           )
//         ],)
//     );
//   }
//
// }
//
