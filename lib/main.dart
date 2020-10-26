import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:gosaudi/screens/profile_screen.dart';
import 'package:gosaudi/screens/registeration_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Saudi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterationScreen.id: (context) => RegisterationScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}