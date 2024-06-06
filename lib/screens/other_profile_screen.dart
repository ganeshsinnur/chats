//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cached_network_image/cached_network_image.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellichat/helper/my_date.dart';
import '../helper/dailogs.dart';
import '../models/chat_user.dart';

class viewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const viewProfileScreen({super.key, required this.user});

  @override
  State<viewProfileScreen> createState() => _viewProfileScreen();
}

class _viewProfileScreen extends State<viewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () {Navigator.of(context).pop();},
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
        ),
        title: const Text("Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            color: Colors.white,
          )
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("User since ${myDateUtil.getLastMessageTime(showYear: true,context: context, time: widget.user.createdAt.toString())}",style:const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),)
                ],
              ), //profile pic + right bottom cam design
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFFB0BEC5)),
                      //Color of icon
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), // Name edit button
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info, color: Color(0xFFB0BEC5)),
                      //Color of icon
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user.about,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(), //about edit button
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onLongPress: ()async {
                      await Clipboard.setData(ClipboardData(text: widget.user.email)).then((value) {Dailogs.showSnackbar(context, 'Mail id copied');
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.mail, color: Color(0xFFB0BEC5)),
                        //Color of icon
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mail id',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.user.email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      const Icon(Icons.not_interested, color: Colors.red),
                      const SizedBox(width: 16),
                      Text("Block ${widget.user.name}",style: const TextStyle(color: Colors.red, fontSize: 16,),),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.thumb_down_alt_sharp, color: Colors.red),
                      //Color of icon
                      const SizedBox(width: 16),
                      Text("Report ${widget.user.name}",style: const TextStyle(color: Colors.red, fontSize: 16,),),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
