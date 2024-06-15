import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/screens/profile_screen.dart';
import 'package:intellichat/widgets/chat_user_card.dart';
import 'package:share_plus/share_plus.dart';

import '../api/apis.dart';
import '../helper/dailogs.dart';
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
    //APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      //log('Message: $message');

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
    String? name = APIs.auth.currentUser?.displayName;
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
          backgroundColor: const Color(0xFF202020),
          //backgroundColor: const Color(0xFF1D2733),
          // backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
              backgroundColor: const Color(0xFF252D3A),
            //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4)),
            //backgroundColor:const Color(0xFF1C1C1C),
            toolbarHeight: 65,
            leading: Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
                child: Builder(
                  builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu_rounded,size: 29,color: Colors.white,)),
                )),
            title: _issearching
                ? TextField(
              style: const TextStyle(
                  fontSize: 17, letterSpacing: 0.5, color: Colors.white,),
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
              decoration:  const InputDecoration(
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  hintText: "Name, Phone, Email"),
            )
                : const Text("I N T E L L I  C H A T",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                    fontFamily: 'Sedan'
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    _issearching = !_issearching;
                    setState(() {});
                  },
                  icon:
                  Icon(_issearching ? Icons.clear : Icons.search_rounded,color: Colors.white,)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              backgroundColor: const Color(0xFF64B4EF),///0xFFE0E0E0
              child: const Icon(Icons.create, /*color: Color(0xFF1C1C1C)*/),
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.grey[900],//const Color(0xFF1C1C1C), // Change drawer color
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  child:Center(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: Image.asset(
                            'assets/images/email.png'
                          ),
                        ),
                        SizedBox(width:10),
                        Text("Intelli Chat",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'Sedan',
                              fontSize: 27
                            ))
                      ],
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.account_circle_outlined, color: Colors.grey),
                  title: const Text('Profile ', style: TextStyle(color: Colors.white)),
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
                  leading: const Icon(Icons.person_add, color: Colors.grey),
                  title: const Text('Invite', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Share.share("Hey, my friend just created a new chat app from scratch! 🎉 "
                        "\nWhy don't we test it out together and experience it firsthand? "
                        "\nJoin me in a chat here: https://drive.google.com/drive/folders/1qpld0T33um21KpbAr8s-4TLsIsboaOT_");
                  },
                ),


              ],
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());

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
                                itemCount: _issearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Chatusercard(
                                      user: _issearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Connections Found!',
                                  style: TextStyle(fontSize: 20, color: Color(0xFFE0E0E0))),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }


  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C), // Background color of the dialog
        contentPadding: const EdgeInsets.only(
            left: 18, right: 18, top: 25, bottom: 25),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        // Title
        title: const Row(
          children: [
            Icon(
              Icons.person_add,
              color: Color(0xFFE0E0E0),
              size: 25,
            ),
            Text('  Add User', style: TextStyle(fontFamily: 'Sedan', color: Color(0xFFE0E0E0)))
          ],
        ),
        // Content
        content: TextFormField(
          style: const TextStyle(color: Colors.white), // Updated text color for dark mode
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            hintText: 'Email Id',
            hintStyle: const TextStyle(color: Colors.white54), // Updated hint text color for dark mode
            prefixIcon: const Icon(Icons.email, color: Color(0xFFE0E0E0)), // Updated icon color for dark mode
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white54)), // Updated border color for dark mode
          ),
        ),
        // Actions
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel',
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
          // Add button
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dailogs.showSnackbar(
                        context, 'User does not Exist!');
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

}
