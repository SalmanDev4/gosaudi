import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/screens/tickets_screen.dart';


class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _disposed = false;
  String userid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getCurrentUser();
  }
 

getCurrentUser() {
FirebaseAuth.instance
  .authStateChanges()
  .listen((User user) {
    if(!_disposed){
      if (user == null) {
      setState(() {
        userid = 'please Sign in or Register';
      });
    } else {
      setState(() {
        userid = user.email;
      });
    }
    }
  });
}
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: CustomContainer(
            body: Column(
              children: [
                Text(userid),
               RaisedButton(onPressed: () async {
                 await FirebaseAuth.instance.signOut();
               },child: Text('Signout'),),
               RaisedButton(onPressed: () => Navigator.pushNamed(context, TicketsScreen.id),child: Text('Tickets'),)
              ],
            ),
          ),
    );
  }
   @override
  void dispose() { 
    _disposed = true;
    super.dispose();
  }
}

