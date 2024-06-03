//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intellichat/screens/profile_screen.dart';
import 'package:intellichat/widgets/chat_user_card.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key,});

  //final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  bool _issearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      //search is on and back button is pressed then close search
      // or else close current screen
      child: WillPopScope(
        onWillPop: () {
          if (_issearching) {
            setState(() {
              _issearching = !_issearching;
            });
            return Future.value(false);
          } else {
            return Future.value(
                true); //if it is false it never returns from the app to back
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF252D3A),
            toolbarHeight: 65,
            leading: Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
                child: Builder(
                  builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Image.asset(
                        "assets/icons/menu.png",
                        width: 25,
                        height: 25,
                        color: Colors.white,
                      )),
                )),
            title: _issearching
                ? TextField(
                    style: const TextStyle(
                        fontSize: 17, letterSpacing: 0.5, color: Colors.white),
                    onChanged: (val) {
                      //searching logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.name.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                        hintText: "Name, Phone, Email"),
                  )
                : const Text("Intelli Chat",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                  onPressed: () {
                    _issearching = !_issearching;
                    setState(() {});
                  },
                  icon:
                      Icon(_issearching ? Icons.clear : Icons.search_rounded)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              backgroundColor: const Color(0xFF64B4EF),
              child: const Icon(Icons.create),
            ),
          ),
          backgroundColor: const Color(0xFF1D2733),
          drawer: Drawer(
            backgroundColor: Colors.grey[900], // Change drawer color
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                  ),
                  accountName: const Text(
                    "hlo",// APIs.me.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: const Text(
                    "APIs.me.email",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                     // width: mq.height * .2,
                      //height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: "APIs.me.image",
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  otherAccountsPictures: [
                    IconButton(
                      icon:
                          Icon(Icons.sunny, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.message, color: Colors.white),
                  title:
                      const Text('Messages', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle the tap
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.account_circle_outlined, color: Colors.white),
                  title: const Text('Profile', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProfileScreen(user: APIs.me),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                    // MaterialPageRoute(builder: (_) => ProfileScreen(user: APIs.me,))
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title:
                      const Text('Settings', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle the tap
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.white),
                  title: const Text('Invite', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle the tap
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading:
                      const Icon(Icons.info_outline_rounded, color: Colors.white),
                  title: const Text('About', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Handle the tap
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          itemCount:
                              _issearching ? _searchList.length : _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Chatusercard(
                                user: _issearching
                                    ? _searchList[index]
                                    : _list[index]);
                            //return Text("Name: ${list[index]}",style: TextStyle(color: Colors.white),);
                          });
                    } else {
                      return const Text("Add users from the below button",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white));
                    }
                }
              }),
        ),
      ),
    );
  }
}
