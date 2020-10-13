import 'package:flutter/material.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:gosaudi/screens/registeration_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
          color: Color(0xFFB7CE73),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60), topRight: Radius.circular(60))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: Icon(Icons.person),
              color: Color(0xFF0F9A4F),
              iconSize: 32,
              onPressed: () {
                Navigator.popAndPushNamed(context, LoginScreen.id);
              }),
          IconButton(
              icon: Icon(Icons.home),
              color: Color(0xFF0F9A4F),
              iconSize: 32,
              onPressed: () {
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
          IconButton(
              icon: Icon(Icons.settings),
              color: Color(0xFF0F9A4F),
              iconSize: 32,
              onPressed: () {
                Navigator.popAndPushNamed(context, RegisterationScreen.id);
              }),
        ],
      ),
    );
  }
}
