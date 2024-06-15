import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/api/apis.dart';
import 'package:intellichat/helper/my_date.dart';
import '../helper/dailogs.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard(
      {super.key,
      required this.message,
      /*required this.replyMessage,required this.rMsg,*/ required this.user});

  final ChatUser user;
  final Message message;

  //final Message replyMessage;
  //final String rMsg;
  //final ValueChanged<Message> onSwipedMessage;

  @override
  State<StatefulWidget> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: widget.message.rMsg == ""
          ? isMe
              ? _buildMessage(const Color(0xFF2F4F4F), Alignment.centerRight,
                  Colors.blue, true)
              : _buildMessage(const Color(0xFF696969), Alignment.centerLeft,
                  Colors.grey, false)
          : isMe
              ? _buildReplyMessage(const Color(0xFF2F4F4F),
                  Alignment.centerRight, Colors.blue, true, Color(0xFF3F6B6B))
              : _buildReplyMessage(const Color(0xFF696969),
                  Alignment.centerLeft, Colors.grey, false, Color(0xFF808080)),
    );
  }

  Widget _buildMessage(
      Color? bgColor, Alignment alignment, Color seenIconColor, bool me) {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.message.type == Type.image ? 4 : 8,
        vertical: widget.message.type == Type.image ? 1 : 4,
      ),
      child: Align(
        alignment: alignment,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  !me ? const Radius.circular(0) : const Radius.circular(20),
              topRight: const Radius.circular(20),
              // me ? const Radius.circular(0) : const Radius.circular(20),
              bottomRight:
                  me ? const Radius.circular(0) : const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .3,
                        fit: BoxFit.cover,
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    myDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (widget.message.read.isNotEmpty && me)
                    Icon(
                      Icons.done_all,
                      color: seenIconColor,
                      size: 17,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyMessage(Color? bgColor, Alignment alignment,
      Color seenIconColor, bool me, Color contColor) {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.message.type == Type.image ? 4 : 8,
        vertical: widget.message.type == Type.image ? 1 : 4,
      ),
      child: Align(
        alignment: alignment,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  !me ? const Radius.circular(0) : const Radius.circular(20),
              topRight: const Radius.circular(20),
              // me ? const Radius.circular(0) : const Radius.circular(20),
              bottomRight:
                  me ? const Radius.circular(0) : const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildReply(me, contColor),
              widget.message.type == Type.text
                  ? Text(
                      widget.message.msg,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .3,
                        fit: BoxFit.cover,
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    myDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (widget.message.read.isNotEmpty && me)
                    Icon(
                      Icons.done_all,
                      color: seenIconColor,
                      size: 17,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(bool me) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D2733),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Info",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              widget.message.type == Type.text
                  ? ListTile(
                      leading: const Icon(Icons.copy_all, color: Colors.blue),
                      title: const Text('Copy',
                          style: TextStyle(color: Colors.white)),
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dailogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  : ListTile(
                      leading: const Icon(Icons.download, color: Colors.blue),
                      title: const Text('Save image',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Implement image saving functionality
                      }),
              if (widget.message.type == Type.text && me)
                ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text('Edit Message',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _editThisMsg();
                    }),
              const Divider(color: Colors.white),
              ListTile(
                  leading: const Icon(Icons.send, color: Colors.blue),
                  title: Text(
                      'Sent at ${myDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {}),
              ListTile(
                  leading: Icon(
                      widget.message.read.isNotEmpty
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue),
                  title: widget.message.read.isNotEmpty
                      ? Text(
                          'Seen at ${myDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                          style: const TextStyle(color: Colors.white))
                      : const Text('Unseen',
                          style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('Delete Message',
                    style: TextStyle(color: Colors.red.shade400)),
                onTap: () async {
                  log("Message deleting");
                  await APIs.deleteMessage(widget.message).then((value) {
                    Navigator.pop(context);
                    Dailogs.showSnackbar(context, 'Message Deleted');
                  });
                  log("Message deleted");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editThisMsg() {
    final mq = MediaQuery.of(context).size;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String updatedMsg = widget.message.msg;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF252D3A),
            content: SizedBox(
              height: mq.height * 0.15,
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          onSaved: (val) => updatedMsg = val ?? '',
                          style: const TextStyle(color: Colors.white),
                          initialValue: updatedMsg,
                          decoration: const InputDecoration(
                            hintText: "eg. Available",
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required Field";
                            }
                            return null;
                          }),
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Color(0xff64b4ef)),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  APIs.updateMessage(
                                      widget.message, updatedMsg);
                                  log('inside validater');
                                  Navigator.pop(context);
                                  Dailogs.showSnackbar(context, "updated!");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0),
                              child: const Text("Save",
                                  style: TextStyle(color: Color(0xff64b4ef))))
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }

  Widget buildReply(bool isMe, Color contColor) => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: contColor, //.withOpacity(.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                color: widget.message.rId == widget.user.id
                    ? Color(0xFF87CEFA)
                    : Color(0xFF90EE90),
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
                        widget.message.rId == widget.user.id
                            ? widget.user.name
                            : "You",
                        style: TextStyle(
                            color: widget.message.rId == widget.user.id
                                ? Color(0xFF87CEFA)
                                : Color(0xFF90EE90)),
                      ),
                      //Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      if (widget.message.rMsg == "Photo") Icon(Icons.photo),
                      Text(
                        widget.message.rMsg,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
}
