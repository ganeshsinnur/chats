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
    //bool isDark = Provider.of<ThemeNotifier>(context).isDarkTheme;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe
            ? _buildMessage(
                Colors.grey, Alignment.centerRight, Colors.blue, true)
            : _buildMessage(
                Colors.white30, Alignment.centerLeft, Colors.grey, false));
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
              topRight:
                  me ? const Radius.circular(0) : const Radius.circular(20),
              bottomRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Column(
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
                  // To provide space for the timestamp
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      myDateUtil.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: const TextStyle(
                        color: Colors.white,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildMessage(Color? bgColor, Alignment alignment, Color seenIconColor, bool me) {
  //   if (widget.message.read.isEmpty) {
  //     APIs.updateMessageReadStatus(widget.message);
  //   }
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: widget.message.type == Type.image ? 4 : 8,
  //       vertical: widget.message.type == Type.image ? 1 : 4,
  //     ),
  //     child: Align(
  //       alignment: alignment,
  //       child: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * 0.8,
  //         ),
  //         decoration: BoxDecoration(
  //           color: bgColor,
  //           borderRadius: BorderRadius.only(
  //             topLeft: !me ? Radius.circular(0) : Radius.circular(20),
  //             topRight: me ? Radius.circular(0) : Radius.circular(20),
  //             bottomRight: Radius.circular(20),
  //             bottomLeft: Radius.circular(20),
  //           ),
  //         ),
  //         padding: const EdgeInsets.all(12),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             widget.message.type == Type.text
  //                 ? Text(
  //               widget.message.msg,
  //               style: const TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 16,
  //               ),
  //             )
  //                 : ClipRRect(
  //               borderRadius: BorderRadius.circular(20),
  //               child: CachedNetworkImage(
  //                 width: MediaQuery.of(context).size.height * .3,
  //                 fit: BoxFit.cover,
  //                 imageUrl: widget.message.msg,
  //                 placeholder: (context, url) => const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: CircularProgressIndicator(),
  //                 ),
  //                 errorWidget: (context, url, error) => const Icon(
  //                   Icons.image,
  //                   size: 70,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 5),
  //             Column(
  //               crossAxisAlignment: me?CrossAxisAlignment.end:CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   myDateUtil.getFormattedTime(
  //                       context: context, time: widget.message.sent),
  //                   style: const TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildMessage(Color? bgColor, Alignment alignment, Color seenIconColor, bool me) {
  //   if (widget.message.read.isEmpty) {
  //     APIs.updateMessageReadStatus(widget.message);
  //   }
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: widget.message.type == Type.image ? 4 : 8,
  //       vertical: widget.message.type == Type.image ? 1 : 4,
  //     ),
  //     child: Align(
  //       alignment: alignment,
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(
  //           maxWidth: MediaQuery.of(context).size.width * 0.8, // Maximum width for chat bubble
  //         ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: bgColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: !me ? Radius.circular(0) : Radius.circular(20),
  //               topRight: me ? Radius.circular(0) : Radius.circular(20),
  //               bottomRight: Radius.circular(20),
  //               bottomLeft: Radius.circular(20),
  //             ),
  //           ),
  //           padding: const EdgeInsets.all(12),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               widget.message.type == Type.text
  //                   ? Text(
  //                 widget.message.msg,
  //                 style: const TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 16,
  //                 ),
  //               )
  //                   : ClipRRect(
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: CachedNetworkImage(
  //                   width: MediaQuery.of(context).size.height * .3,
  //                   fit: BoxFit.cover,
  //                   imageUrl: widget.message.msg,
  //                   placeholder: (context, url) => const Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                   errorWidget: (context, url, error) => const Icon(
  //                     Icons.image,
  //                     size: 70,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       myDateUtil.getFormattedTime(
  //                           context: context, time: widget.message.sent),
  //                       style: const TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 12,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 5),
  //                     if (widget.message.read.isNotEmpty && me)
  //                       Icon(
  //                         Icons.done_all,
  //                         color: seenIconColor,
  //                         size: 17,
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildMessage(Color? bgColor, Alignment alignment, Color seenIconColor,bool me) {
  //   if (widget.message.read.isEmpty) {
  //     APIs.updateMessageReadStatus(widget.message);
  //   }
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: widget.message.type == Type.image ? 4 : 8,
  //       vertical: widget.message.type == Type.image ? 1 : 4,
  //     ),
  //     child: Align(
  //       //widthFactor:4 ,
  //       alignment: alignment,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width*.3,
  //         decoration: BoxDecoration(
  //           color: bgColor,
  //           borderRadius:  BorderRadius.only(
  //             topLeft: !me?Radius.circular(0):Radius.circular(20),
  //             topRight: me?Radius.circular(0):Radius.circular(20),
  //             bottomRight: Radius.circular(20),
  //             bottomLeft: Radius.circular(20),
  //           ),
  //         ),
  //         padding: const EdgeInsets.all(12),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             widget.message.type == Type.text
  //                 ? Text(
  //               widget.message.msg,
  //               style: const TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 16,
  //               ),
  //             )
  //                 : ClipRRect(
  //               borderRadius: BorderRadius.circular(20),
  //               child: CachedNetworkImage(
  //                 width: MediaQuery.of(context).size.height * .3,
  //                 fit: BoxFit.cover,
  //                 imageUrl: widget.message.msg,
  //                 placeholder: (context, url) => const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: CircularProgressIndicator(),
  //                 ),
  //                 errorWidget: (context, url, error) => const Icon(
  //                   Icons.image,
  //                   size: 70,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 5),
  //             Align(
  //               alignment: Alignment.bottomRight,
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     myDateUtil.getFormattedTime(
  //                         context: context, time: widget.message.sent),
  //                     style: const TextStyle(
  //                       color: Colors.grey,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 5),
  //                   if (widget.message.read.isNotEmpty&& me)
  //                     Icon(
  //                       Icons.done_all,
  //                       color: seenIconColor,
  //                       size: 17,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
                      }) // Copy
                  : ListTile(
                      leading: const Icon(Icons.download, color: Colors.blue),
                      title: const Text('Save image',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Implement image saving functionality
                      }), // Save
              if (widget.message.type == Type.text && me)
                ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text('Edit Message',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _editThisMsg();
                    }), // Edit Message
              const Divider(color: Colors.white),
              ListTile(
                  leading: const Icon(Icons.send, color: Colors.blue),
                  title: Text(
                      'Sent at ${myDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {}), // Sent at
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
                  }), // Seen at
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
              // Seen at
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
            //title: Text("edit"),
            backgroundColor: const Color(0xFF252D3A),
            content: SizedBox(
              height: mq.height * 0.15,
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          //controller: TextEditingController(),
                          onSaved: (val) => updatedMsg = val ?? '',
                          style: const TextStyle(color: Colors.white),
                          initialValue: updatedMsg,
                          decoration: const InputDecoration(
                            hintText: "eg. Available",
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
}
