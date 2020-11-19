import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({@required this.body,@required this.title, this.drawer, this.floatingActionButton,this.bottomNavBar});

  final Widget body;
  final Widget floatingActionButton;
  final Widget drawer;
  final Widget bottomNavBar;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xFF0F9A4F), Color(0xFFE7DC7D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
        child: Scaffold(
    appBar: AppBar(
      title: title,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    backgroundColor: Colors.transparent,
    body: body,
    drawer: drawer,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavBar,
        ),
      );
  }
}
