import 'package:flutter/material.dart';
import 'package:gosaudi/MyBottomNavBar.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({@required this.body, this.drawer, this.floatingActionButton});

  final Widget body;
  final Widget floatingActionButton;
  final Widget drawer;

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
      title: Text('Go Saudi'),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    backgroundColor: Colors.transparent,
    body: body,
    drawer: drawer,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: MyBottomNavBar(),
        ),
      );
  }
}
