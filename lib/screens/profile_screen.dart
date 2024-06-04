//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellichat/helper/dailogs.dart';
import 'package:intellichat/screens/HomeScreen.dart';
import 'package:intellichat/screens/LoginScreen.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF252D3A),
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
        ),
        title: const Text("Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.ellipsis_vertical),color: Colors.white,)],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await APIs.updateActiveStatus(false);
            Dailogs.showProgressbar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pop(context);

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              });
            });
          },
          backgroundColor: const Color(0xFF64B4EF),
          icon: const Icon(Icons.logout),
          label: Text("Logout"),
        ),
      ),
      backgroundColor: const Color(0xFF1D2733),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  //Profile Photo
                  _image != null
                  //local image
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: Image.file(
                            File(_image!),
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                          ),
                        )
                  //image from server
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                  // CircleAvatar(
                  //   radius: 70, //if possible use : CachedNetworkImage(}
                  //   backgroundImage: NetworkImage(
                  //     widget.user.image,
                  //   ),
                  // ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF64B4EF),
                      child: IconButton(
                        onPressed: () {
                          _showBottomSheet();
                          print("icon btn pressed");
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ), //Image update button
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
                      const Icon(Icons.person, color: Color(0xFF64B4EF)),
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
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFF252D3A),
                                  //title: Text("edit"),
                                  content: Container(
                                    height: mq.height * 0.15,
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                //controller: TextEditingController(),
                                                onSaved: (val) =>
                                                    APIs.me.name = val ?? '',
                                                initialValue: widget.user.name,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "eg. Available",
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required Field";
                                                  }
                                                  return null;
                                                }),
                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff64b4ef)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _formKey.currentState!
                                                            .save();
                                                        APIs.updateUserInfo();
                                                        log('inside validater');
                                                        Navigator.pop(context);
                                                        Dailogs.showSnackbar(
                                                            context, "Saved!");
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0),
                                                    child: const Text("Save",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff64b4ef))))
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFF64B4EF),
                        ),
                      ) // Name edit button
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is not your username or pin. This name will be visible to your friends on Intelli Chat.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.info, color: Color(0xFF64B4EF)),
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
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  //title: Text("edit"),
                                  backgroundColor: Color(0xFF252D3A),
                                  content: Container(
                                    height: mq.height * 0.15,
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                                //controller: TextEditingController(),
                                                onSaved: (val) =>
                                                    APIs.me.about = val ?? '',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                initialValue: widget.user.about,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "eg. Available",
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required Field";
                                                  }
                                                  return null;
                                                }),
                                            Row(
                                              children: [
                                                Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff64b4ef)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _formKey.currentState!
                                                            .save();
                                                        APIs.updateUserInfo();
                                                        log('inside validater');
                                                        Navigator.pop(context);
                                                        Dailogs.showSnackbar(
                                                            context, "Saved!");
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            elevation: 0),
                                                    child: const Text("Save",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff64b4ef))))
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFF64B4EF),
                        ),
                      ) //about edit button
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ProfileDetail(
                  //   icon: Icons.mail,
                  //   title: 'Mail',
                  //   detail: widget.user.email,
                  // ),
                  InkWell(
                    onLongPress: ()async {
                      await Clipboard.setData(ClipboardData(text: widget.user.email)).then((value) {Dailogs.showSnackbar(context, 'Mail id copied');
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.mail, color: Color(0xFF64B4EF)),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //bottom sheet to popup for updating profile
  void _showBottomSheet() {
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
                "Profile Photo",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                  await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                  if (image != null) {
                    setState(() {_image=image.path;});
                    log('Image Path: ${image.path}--Mimetype: ${image.mimeType}');
                    APIs.updateProfilePicture(File(_image!));
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.blue),
                title: const Text('Gallery',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                  if (image != null) {
                    setState(() {_image=image.path;});
                    log('Image Path: ${image.path}--Mimetype: ${image.mimeType}');
                    APIs.updateProfilePicture(File(_image!));
                    Navigator.pop(context);
                  }
                },
              ),
              // ListTile(      //list tile for avatar
              //   leading: Icon(Icons.emoji_emotions, color: Colors.blue),
              //   title: Text('Avatar', style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     // Handle avatar tap
              //     Navigator.pop(context);
              //   },
              // ),
              //SizedBox(height: 20),
              const Divider(color: Colors.white),
              // Divider Color
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('Delete',
                    style: TextStyle(color: Colors.red.shade400)),
                onTap: () {
                  // Handle delete tap
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
