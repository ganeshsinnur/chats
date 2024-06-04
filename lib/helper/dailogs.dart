import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

class Dailogs{
  static void showSnackbar(BuildContext context, String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.black12,   //snack bar color background
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 1),        //durtaion of snackbar
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 50),   //size of snackbar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),   //rounded corner
    ));
  }

  static void showProgressbar(BuildContext context){
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()) );

  }



}

