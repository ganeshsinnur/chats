import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier{
  bool _isDarkTheme =false;
  bool get isDarkTheme =>_isDarkTheme;

  ThemeData get currentTheme => _isDarkTheme? ThemeData.dark():ThemeData.light();

  void toggleTheme(){
    _isDarkTheme= !_isDarkTheme;
    notifyListeners();
  }
}