import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellichat/models/chat_user.dart';
import 'package:intellichat/widgets/message_card.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../api/apis.dart';
import '../helper/my_date.dart';
import '../models/message.dart';
import 'other_profile_screen.dart';

class ChatScreen extends StatefulWidget{
  final ChatUser user;
  const ChatScreen({super.key, required this.user});


  @override
  State<ChatScreen> createState()=>_ChatScreen();
}

class _ChatScreen extends State<ChatScreen>{

  List<Message> _list =[];

  final _textController =TextEditingController();

  bool  _showemoji = false,_isUploading=false;



  @override

  Widget build(BuildContext context){
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //SystemChrome.setEnabledSystemUIMode(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.green,statusBarColor: Colors.green) as SystemUiMode );
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: SafeArea(
      
        child: WillPopScope(
          onWillPop: (){
            if(_showemoji){
              setState(() {_showemoji = !_showemoji;});
              return Future.value(false);
            }else{
              return Future.value(true);                //if it is false it never returns from the app to back
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1C1C1C),
              toolbarHeight: 65,
              automaticallyImplyLeading: false,
              flexibleSpace:_appBar() ,
            ),
            backgroundColor: const Color(0xFF121212),
            body:Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMesseages(widget.user),

                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                        //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                        //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                            _list.sort((b, a) => a.sent.compareTo(b.sent));


                            //final _list =["Hello","Hi"];
                            //      _list.clear();
                            //      _list.add(Message(msg: 'Hiii', read: '', told: 'XYZ', type: Type.text, fromId: APIs.user.uid, sent: '12:00 AM'));
                            //      _list.add(Message(msg: 'Hello', read: '', told: APIs.user.uid, type: Type.text, fromId: 'XYZ', sent:' 12:05 AM'));

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse:true,
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                                  itemCount:_list.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCard(message: _list[index],);
                                  });
                            } else {
                              return const Center(
                                child: Text("Say Hello",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, color: Colors.blue,fontSize: 20)),
                              );
                            }
                        }
                      }),
                ),

                if(_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                        child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 30,
                          //strokeWidth: 2,
                          color: Colors.blue,
                        ),
                      )),

                // const Align(
                //   alignment: Alignment.centerRight,
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         color: Colors.blue,
                //       ),
                //     )),
                _chatInput(),
                //import 'package:flutter/foundation.dart' as foundation;
                if(_showemoji)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.40,
                    child: EmojiPicker(
                      textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          columns: 8,
                          backgroundColor: Colors.black12,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ?  1.20 :  1.0),
                        ),
                        //swapCategoryAndBottomBar:  false,
                        //skinToneConfig: const SkinToneConfig(),
                        //categoryViewConfig: const CategoryViewConfig(),
                        //bottomActionBarConfig: const BottomActionBarConfig(),
                        //searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  )


              ],
            )




          ),
        ),
      ),
    );
  }

  Widget _appBar(){
    var mq=MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        //Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                viewProfileScreen(user: widget.user),
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
      child: StreamBuilder(stream: APIs.getUserInfo(widget.user), builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];


        return Row(
          children: [
            IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height*.0275),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: mq.height*.05,
                height: mq.height*.05,
                imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(child: Icon(CupertinoIcons.person_crop_square),),
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list.isNotEmpty ? list[0].name : widget.user.name,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
               // Text(list.isNotEmpty ? list[0].isOnline ? 'Online' : myDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)// : myDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),style: TextStyle(color: Colors.white70,fontSize: 10),)
                list.isNotEmpty ? list[0].isOnline ?const Text("Online",style: TextStyle(color: Colors.green,fontSize: 13),):Text(myDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive),style: const TextStyle(color: Colors.white70,fontSize: 10),):Text(myDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),style: const TextStyle(color: Colors.white70,fontSize: 10),)

              ],
            )

          ],);
      },),
    );
  }

  Widget _chatInput() {
    var mq=MediaQuery.of(context).size;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical:mq.height*.01,horizontal: mq.width*.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)) ,
              elevation: 1,
              child: Row(
                children: [
                  IconButton(onPressed: (){
                        FocusScope.of(context).unfocus();
                    setState((){_showemoji = !_showemoji;});},
                      icon: const Icon(Icons.emoji_emotions_outlined,color: Color(0xFF64B4EF),)),
                    Expanded(
                      child: TextField(
                        onTap: (){if(_showemoji){setState(() {_showemoji= !_showemoji;});}},
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "type something.....",
                          hintStyle: TextStyle(color: Color(0xFF64B4EF)),
                          border: InputBorder.none
                        ),
                      )),
                  IconButton(onPressed: ()async {
                    final ImagePicker picker = ImagePicker();
                    final List<XFile>? images =await picker.pickMultiImage(imageQuality: 80);
                    if (images!.isNotEmpty){
                      for(var i in images){
                        setState(() {_isUploading= true;});
                        //log('Image Path: ${image.path}--Mimetype: ${image.mimeType}');
                        await APIs.sendChatImage(widget.user,File(i.path));
                        setState(() {_isUploading= false;});
                      }
                    }
                  }, icon: const Icon(Icons.photo,color: Color(0xFF64B4EF),)),


                  IconButton(onPressed: ()async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                    await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                    if (image != null) {
                      //log('Image Path: ${image.path}--Mimetype: ${image.mimeType}');
                      setState(() {_isUploading= true;});
                      await APIs.sendChatImage(widget.user,File(image.path));
                      setState(() {_isUploading= false;});
                    }
                  }, icon: const Icon(Icons.camera_alt,color: Color(0xFF64B4EF),))

                ],
              ),
            ),
          ),
          //sending button
          MaterialButton(onPressed: (){
            if (_textController.text.isNotEmpty) {
              if (_list.isEmpty) {
                //on first message (add user to my_user collection of chat user)
                APIs.sendFirstMessage(
                    widget.user, _textController.text, Type.text);
              } else {
                //simply send message
                APIs.sendMessage(
                    widget.user, _textController.text, Type.text);
              }
              _textController.text = '';
            }
          },
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5),
            shape: const CircleBorder(),
            color: const Color(0xFF64B4EF),
            child: const Icon(Icons.send,color: Colors.black,),)
        ],
      ),
    );
  }
}


