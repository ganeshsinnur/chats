import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/api/apis.dart';
import 'package:intellichat/helper/my_date.dart';

import '../helper/dailogs.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

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
        child: isMe ? _greenMessage() : _blueMessage());
  }

  //card from chatGPt
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('msg read updated');
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.message.type == Type.image ? 4 : 8,
        vertical: widget.message.type == Type.image ? 1 : 4,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      borderRadius: BorderRadius.circular(0),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .3,
                        //height: MediaQuery.of(context).size.height * .2,
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
              const SizedBox(height: 5),
              Text(
                myDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //our(user) msg
  Widget _greenMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.message.type == Type.image ? 4 : 8,
        vertical: widget.message.type == Type.image ? 1 : 4,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
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
                      borderRadius: BorderRadius.circular(0),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * .3,
                        //height: MediaQuery.of(context).size.height * .2,
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
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    myDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  if (widget.message.read.isNotEmpty)
                    const Icon(
                      Icons.done_all,
                      color: Colors.blue,
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showBottomSheet(bool me) {
    // var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D2733),
      // Background color for the bottom sheet
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
                " ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              widget.message.type == Type.text
                  ? ListTile(
                      leading: const Icon(Icons.copy_all, color: Colors.blue),
                      title:
                          const Text('Copy', style: TextStyle(color: Colors.white)),
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dailogs.showSnackbar(context, 'Text Copied!');
                        });
                      }) //copy
                  : ListTile(
                      leading: const Icon(Icons.download, color: Colors.blue),
                      title: const Text('Save image',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {}), //save
              // if (widget.message.type == Type.text && me)
              //   ListTile(
              //       leading: const Icon(Icons.edit, color: Colors.blue),
              //       title: const Text('Edit Message',
              //           style: TextStyle(color: Colors.white)),
              //       onTap: () {
              //         Navigator.pop(context);
              //       }), //Edit Message
              const Divider(color: Colors.white),
              ListTile(
                  leading: const Icon(Icons.send, color: Colors.blue),
                  title: Text(
                      'Sent at ${myDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {}), //Sent at
              ListTile(
                  leading:  Icon(
                      widget.message.read.isNotEmpty
                      ?Icons.visibility
                      :Icons.visibility_off, color: Colors.blue),
                  title: widget.message.read.isNotEmpty
                      ? Text(
                          'Seen at ${myDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                          style: const TextStyle(color: Colors.white))
                      : const Text('Unseen', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  }), //Seen at
              const Divider(color: Colors.white),
              // ListTile(
              //   leading: const Icon(Icons.delete, color: Colors.red),
              //   title: Text('Delete Message',
              //       style: TextStyle(color: Colors.red.shade400)),
              //   onTap: () {
              //     APIs.deleteMessage(widget.message);
              //     Navigator.pop(context);
              //   },
              // ), //Delete Message
              //Seen at
            ],
          ),
        );
      },
    );
  }
}
