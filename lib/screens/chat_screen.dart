import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart' as rely;
import 'package:image_picker/image_picker.dart';
import 'package:intellichat/models/chat_user.dart';
import 'package:intellichat/widgets/message_card.dart';
import 'package:swipe_to/swipe_to.dart';
import '../api/apis.dart';
import '../helper/my_date.dart';
import '../models/message.dart';
import 'other_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  List<String> Replies = ['Hi there!', 'How are you?', 'Hello'];
  final _textController = TextEditingController();
  bool _isUploading = false;
  final _smartReply = rely.SmartReply();
  final focusNode = FocusNode();
  late Message replyMessage;
  String rMessage = '';
  String rId = "";

  //bool isReply = false;

  ///replyMessage!=null;

  @override
  void dispose() {
    _smartReply.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF252D3A),
            toolbarHeight: 65,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpeg"),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMesseages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          _list.sort((b, a) => a.sent.compareTo(b.sent));
                          replyMessage = _list[0];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01),
                              itemCount: _list.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                addMsgtoReply(
                                    _list[index]); // Add messages to SmartReply
                                getSuggestions();
                                return SwipeTo(
                                    onRightSwipe: (details) {
                                      onSwipedmessage(_list[index]);
                                    },
                                    child: MessageCard(
                                      message: _list[index],
                                      user: widget.user,
                                    ));
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                "Say Hello",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                    fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                      child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                StreamBuilder(
                  stream: APIs.getAllMesseages(widget.user),
                  builder: (context, snapshot) {
                    //getSuggestions();
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: (Replies.isNotEmpty)
                          ? Row(
                              children: [
                                chip(Replies[0]),
                                const SizedBox(width: 5),
                                chip(Replies[1]),
                                const SizedBox(width: 5),
                                chip(Replies[2]),
                              ],
                            )
                          : null,
                    );
                  },
                ),
                _chatInput(focusNode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    var mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
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
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.0275),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.height * 0.05,
                  height: mq.height * 0.05,
                  imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person_crop_square)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  list.isNotEmpty
                      ? list[0].isOnline
                          ? Text('Online',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 12))
                          : Text(
                              myDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 10))
                      : Text(
                          myDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 10)),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _chatInput(FocusNode focusNode) {
    var mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color(0xFF464D52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 1,
              child: Column(
                children: [
                  if (rMessage.isNotEmpty) buildReply(replyMessage),
                  Row(
                    children: [
                      SizedBox(width: mq.width * .05),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          //onTap: () {},
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Say Hello...",
                            hintStyle: TextStyle(color: Color(0xFF64B4EF)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final List<XFile>? images =
                              await picker.pickMultiImage(imageQuality: 80);
                          if (images != null && images.isNotEmpty) {
                            setState(() {
                              _isUploading = true;
                            });
                            for (var i in images) {
                              await APIs.sendChatImage(
                                  widget.user, File(i.path), rMessage, rId);
                            }
                            cancelReply();
                            setState(() {
                              _isUploading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo, color: Color(0xFFB1CDE7)),
                      ),
                      IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            setState(() {
                              _isUploading = true;
                            });
                            await APIs.sendChatImage(
                                widget.user, File(image.path), rMessage, rId);
                            cancelReply;
                            setState(() {
                              _isUploading = false;
                            });
                          }
                        },
                        icon: const Icon(Icons.camera_alt,
                            color: Color(0xFF64B4EF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //sending button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(widget.user, _textController.text,
                      Type.text, rMessage, rId);
                } else {
                  //simply send message
                  APIs.sendMessage(widget.user, _textController.text, Type.text,
                      rMessage, rId);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            shape: const CircleBorder(),
            color: const Color(0xFF64B4EF),
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget chip(String label) {
    // Customised Chip widget
    return Expanded(
      child: GestureDetector(
          onTap: () {
            if (_list.isEmpty) {
              //on first message (add user to my_user collection of chat user)
              APIs.sendFirstMessage(
                  widget.user, _textController.text, Type.text, rMessage, rId);
            } else {
              //simply send message
              APIs.sendMessage(
                  widget.user, _textController.text, Type.text, rMessage, rId);
            }
            getSuggestions();
            cancelReply();
          },
          child: Chip(label: Center(child: Text(label)))),
    );
  }

  Future<void> getSuggestions() async {
    // Fetch suggestions using Google ML Kit and rebuild page
    List oldSuggestions = Replies;
    final response = await _smartReply.suggestReplies();
    //log('curr Replies: $Replies');
    Replies = response.suggestions;
    //log('after Replies: $Replies');
    if (!listEquals(oldSuggestions, Replies)) {
      setState(() {});
    }
  }

  void addMsgtoReply(Message message) {
    bool isMe = APIs.user.uid == message.fromId;
    if (isMe) {
      //log("isMe--> msg:${message.msg} timestamp:${myDateUtil.getTimeDate(context: context, time: message.sent)}");
      _smartReply.addMessageToConversationFromLocalUser(
          message.msg, int.parse(message.sent));
    } else {
      // log("remote user--> msg:${message.msg} timestamp:${myDateUtil.getTimeDate(context: context, time: message.sent)}");
      _smartReply.addMessageToConversationFromRemoteUser(
          message.msg, int.parse(message.sent), message.fromId);
    }
  }

  onSwipedmessage(Message message) {
    replyToMessage(message);
    focusNode.requestFocus();
  }

  void replyToMessage(Message message) {
    rId = message.fromId;
    setState(() {
      replyMessage = message;
      rMessage = message.type == Type.text ? message.msg : "Photo";
    });
  }

  void cancelReply() {
    rId = "";
    setState(() {
      rMessage = '';
      //replyMessage=null;
    });
  }

  Widget buildReply(Message message) => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Color(0xCC5A5A5A), //.withOpacity(.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                color: widget.user.id == message.fromId
                    ? Colors.blue
                    : Colors.green,
                width: 4,
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user.id == message.fromId
                            ? widget.user.name
                            : APIs.me.name,
                        style: TextStyle(
                            color: widget.user.id == message.fromId
                                ? Colors.blue
                                : Colors.green),
                      ),
                      //Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      if (rMessage == "Photo") Icon(Icons.photo),
                      Text(
                        rMessage,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              GestureDetector(child: Icon(Icons.close), onTap: cancelReply)
            ],
          ),
        ),
      );
}
