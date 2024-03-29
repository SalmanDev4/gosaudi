import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/screens/hotels_screen.dart';
import 'package:gosaudi/screens/information_screen.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:gosaudi/screens/profile_screen.dart';
import 'package:gosaudi/screens/registeration_screen.dart';
import 'package:gosaudi/screens/tickets_screen.dart';
import 'package:gosaudi/screens/trip_screen.dart';
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
        fontFamily: 'Montserrat',
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
        TicketsScreen.id: (context) => TicketsScreen(),
        InformationScreen.id: (context) => InformationScreen(),
        HotelsScreen.id: (context) => HotelsScreen(),
        TripScreen.id: (context) => TripScreen(),
      },
    );
  }
}