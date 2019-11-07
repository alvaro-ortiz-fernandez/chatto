import 'package:chatto/screens/login-screen.dart';
import 'package:chatto/screens/home-screen.dart';
import 'package:chatto/screens/profile-screen.dart';
import 'package:chatto/screens/signup-screen.dart';
import 'package:chatto/screens/users-screen.dart';
import 'package:chatto/services/auth-service.dart';
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
      home: /*getAuthScreen() HomeScreen(currentIndex: 0) LoginScreen() SignupScreen() ProfileScreen()
              UsersScreen(currentIndex: 0)*/ AuthService.getAuthScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        HomeScreen.id: (context) => HomeScreen(currentIndex: 0)
      },
    );
  }
}