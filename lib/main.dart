import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/login-screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2764EB),
        accentColor: Color(0xFFF2F2F2)
      ),
      home: /*HomeScreen()*/ LoginScreen(),
    );
  }
}