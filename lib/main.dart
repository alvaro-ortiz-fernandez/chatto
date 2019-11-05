import 'package:chatto/screens/login-screen.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff454dff),
        accentColor: Color(0xFFF6F7F2),
        fontFamily: 'GilroyRegular'
      ),
      home: /*HomeScreen(currentIndex: 0) LoginScreen() ProfileScreen()
              UsersScreen(currentIndex: 0)*/ LoginScreen(),
    );
  }
}