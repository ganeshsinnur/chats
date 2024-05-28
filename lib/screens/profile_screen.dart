//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intellichat/screens/HomeScreen.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';


class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}
class _ProfileScreen extends State<ProfileScreen>{


  @override
  Widget build(BuildContext context) {
    var mq =MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF252D3A),
        toolbarHeight: 65,
        leading: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
        }, icon: const Icon(Icons.arrow_back_rounded) ),
        // leading:  Container(
        //     margin: const EdgeInsets.only(left: 10,top:5),
        //     child: IconButton(onPressed: (){}, icon: Image.asset("assets/icons/menu.png", width: 25, height: 25,color: Colors.white,) )),
        title: const Text("Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(onPressed: ()async{
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },
          child: Icon(Icons.create),
          backgroundColor: const Color(0xFF64B4EF),),
      ),
      backgroundColor: const Color(0xFF1D2733),
      body: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height*0.1),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            width: mq.height*.3,
            height: mq.height*.3,
            imageUrl: widget.user.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
          ),
        ),
      ),
    );
  }
}

