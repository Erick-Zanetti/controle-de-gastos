import 'dart:io';

import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0x000000),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  platform: (Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.deepPurple[300],
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.deepPurple,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  platform: (Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: Colors.grey,
    selectedItemColor: Colors.deepPurple[300],
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
);

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}
