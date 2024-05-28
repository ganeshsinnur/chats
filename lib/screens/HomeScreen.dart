//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intellichat/screens/profile_screen.dart';
import 'package:intellichat/widgets/chat_user_card.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{

   List<ChatUser> list =[];

  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF252D3A),
        toolbarHeight: 65,
        leading:  Container(
            margin: EdgeInsets.only(left: 10,top:5),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>  ProfileScreen(user: list[0],)));
            }, icon: Image.asset("assets/icons/menu.png", width: 25, height: 25,color: Colors.white,) )),
        title: Text("Intelli Chat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: (){}, icon: Image.asset("assets/icons/search.png", width: 25, height: 25,color: Colors.white,) ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(onPressed: ()async{
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },
        child: Icon(Icons.create),
          backgroundColor: Color(0xFF64B4EF),),
      ),
      backgroundColor: Color(0xFF1D2733),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {

          switch (snapshot.connectionState){
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child:CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:


              final data = snapshot.data?.docs;
              list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty){
              return ListView.builder(
                  padding: EdgeInsets.only(top: mq.height * 0.01),
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context,index){
                    return  Chatusercard(user : list[index]);
                    //return Text("Name: ${list[index]}",style: TextStyle(color: Colors.white),);
                  });
            }else{
              return const Text("Connection not found",style:TextStyle(fontWeight: FontWeight.w500,color: Colors.white));
            }
          }
        }
      ),
    );
  }

}

