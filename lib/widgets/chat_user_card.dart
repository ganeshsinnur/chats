import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';

class Chatusercard extends StatefulWidget{
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatUserCardState();

}

class _ChatUserCardState extends State<Chatusercard>{
  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: mq.width *0.01 ),
      color: const Color(0xFF1D2733),
      child: InkWell(
        onTap: (){},
        child:  ListTile(
          //leading: const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              width: mq.height*.055,
              height: mq.height*.055,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
            ),
          ),
          title: Text(widget.user.name,style:  TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
          subtitle: Text(widget.user.about,style:  TextStyle(color: Colors.white38), maxLines: 1,),
          //trailing: const Text("12:00 AM",style: TextStyle(color: Colors.white38),),
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF64B4EF),
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ),
      ),
    );
  }
}