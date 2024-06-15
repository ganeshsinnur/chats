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
    //APIs.getSelfInfo();
    //APIs.getSelfInfo();
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
        log('User: ${APIs.auth.currentUser}');
        //APIs.getSelfInfo();
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
