import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellichat/api/apis.dart';
import 'package:intellichat/helper/my_date.dart';
import 'package:intellichat/models/message.dart';

import '../models/chat_user.dart';
import '../screens/chat_screen.dart';
import 'dailog.dart';

class Chatusercard extends StatefulWidget{
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatUserCardState();

}

class _ChatUserCardState extends State<Chatusercard>{
  //last msg info if null no msg
  Message? _message;

  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: mq.width *0.01 ),
      color: const Color(0xFF1D2733),
      child: InkWell(
        onTap: (){ // navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));
        },
        child:  StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context,snapshot){
            final data = snapshot.data?.docs;
            final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty){
              _message = list[0];
            }
            return ListTile(
              //leading: const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height*.0275),
                  child: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (_)=>ProfileDialog(user: widget.user,));
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: mq.height*.055,
                      height: mq.height*.055,
                      imageUrl: widget.user.image,
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
                    ),
                  ),
                ),
                title: Text(widget.user.name,style:  TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
                subtitle: _message == null
                    ?Text( widget.user.about,style:TextStyle(color: Colors.white38),maxLines: 1)
                    :_message!.type == Type.image
                    ? Row(children: [Icon(Icons.image,size: 15,),Text("Image",style:  TextStyle(color: Colors.white38))],)
                    :Text(_message!.msg,style:  const TextStyle(color: Colors.white38),maxLines: 1,),
                //Text( _message == null ? widget.user.about :_message!.type == Type.image ? 'image' : _message!.msg , maxLines: 1 ,style:  TextStyle(color: Colors.white38), ),
                //trailing: const Text("12:00 AM",style: TextStyle(color: Colors.white38),),
                trailing: _message==null?null:
                _message!.read.isEmpty && _message!.fromId != APIs.user.uid?
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color(0xFF64B4EF),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ):Text(myDateUtil.getLastMessageTime(context: context,time:_message!.sent),style: TextStyle(color: Colors.white38),)
            );
          
        }, )
      ),
    );
  }
}