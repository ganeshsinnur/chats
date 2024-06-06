
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    //var mq=MediaQuery.of(context).size;
    //var customTheme=0; //0 for dark; 1for light


    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
    // return MaterialApp(
    //
    //     debugShowCheckedModeBanner: false,
    //     title: 'Intelli Chat',
    //     theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //         appBarTheme: const AppBarTheme(
    //             elevation: 1,
    //             iconTheme: IconThemeData(color: Colors.black),
    //             titleTextStyle: TextStyle(
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.normal,
    //                 fontSize: 19)
    //         )),
    //
    //     home: const SplashScreen()//const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
