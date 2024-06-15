import 'package:flutter/material.dart';


class Dailogs{
  static void showSnackbar(BuildContext context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,style: TextStyle(color: Colors.white),),
      backgroundColor: Color(0xFF121212),   //snack bar color background
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),        //duration of snack bar
      margin: const EdgeInsets.symmetric(horizontal: 40,vertical: 50),   //size of snack bar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),   //rounded corner
    ));
  }

  static void showProgressbar(BuildContext context){
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()) );

  }



}

