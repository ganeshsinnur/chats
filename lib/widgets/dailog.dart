import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import '../../main.dart';
import '../../models/chat_user.dart';

// import '../../screens/view_profile_screen.dart';
import '../screens/other_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.9,
                  // width: MediaQuery.of(context).size.width * .6,
                  //height: MediaQuery.of(context).size.width * .6,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(Icons.info_outline_rounded, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => viewProfileScreen(user: user)));
                  },
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // AlertDialog(
    //   contentPadding: EdgeInsets.zero,
    //   backgroundColor: Colors.white.withOpacity(.9),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   content: SizedBox(
    //       width: MediaQuery.of(context).size.width * .6,
    //       height: MediaQuery.of(context).size.height * .4,
    //       child: Stack(
    //         children: [
    //           //user profile picture
    //           Positioned(
    //             //top: MediaQuery.of(context).size.height * .075,
    //             //left: MediaQuery.of(context).size.width * .1,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .0),
    //               child: Center(
    //                 child: CachedNetworkImage(
    //                   width: MediaQuery.of(context).size.width * .6,
    //                   height: MediaQuery.of(context).size.width * .6,
    //                   fit: BoxFit.cover,
    //                   imageUrl: user.image,
    //                   errorWidget: (context, url, error) =>
    //                   const CircleAvatar(child: Icon(CupertinoIcons.person)),
    //                 ),
    //     ),
    //   ),
    // ),
    //
    //           //user name
    //           Positioned(
    //             left: MediaQuery.of(context).size.width * .04,
    //             top: MediaQuery.of(context).size.height * .02,
    //             width: MediaQuery.of(context).size.width * .55,
    //             child: Text(user.name,
    //                 style: const TextStyle(
    //                     fontSize: 18, fontWeight: FontWeight.w500)),
    //           ),
    //
    //           //info button
    //           Positioned(
    //               right: 8,
    //               top: 6,
    //               child: MaterialButton(
    //                 onPressed: () {
    //                   //for hiding image dialog
    //                   Navigator.pop(context);
    //
    //                   //move to view profile screen
    //                   Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (_) => viewProfileScreen(user: user)));
    //                 },
    //                 minWidth: 0,
    //                 padding: const EdgeInsets.all(0),
    //                 shape: const CircleBorder(),
    //                 child: const Icon(Icons.info_outline,
    //                     color: Colors.blue, size: 30),
    //               ))
    //         ],
    //       )),
    // );
  }
}
