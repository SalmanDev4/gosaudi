import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: CustomContainer(
            body: Column(
              children: [
                Text('Test'),
              ],
            ),
          ),
    );
  }
}
