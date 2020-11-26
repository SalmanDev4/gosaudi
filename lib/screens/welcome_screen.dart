import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/auth.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/screens/hotels_screen.dart';
import 'package:gosaudi/screens/information_screen.dart';
import 'package:gosaudi/screens/profile_screen.dart';
import 'package:gosaudi/screens/tickets_screen.dart';
import 'package:gosaudi/screens/trip_screen.dart';

// This is the main screen of the App.

final String screenName = 'Go Saudi App';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _disposed = false;
  String userEmail = '';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
// Get current loggedIn user or showing as a Guest.
  getCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (!_disposed) {
        if (user == null) {
          setState(() {
            userEmail = 'Guest';
          });
        } else {
          setState(() {
            userEmail = user.email;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomContainer(
          title: Text(screenName),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF0F9A4F), Color(0xFFE7DC7D)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Go Saudi App'),
                      Text('Welcome $userEmail')
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pushNamed(context, ProfileScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event),
                  title: Text('Tickets'),
                  onTap: () {
                    Navigator.pushNamed(context, TicketsScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text('Information'),
                  onTap: () {
                    Navigator.pushNamed(context, InformationScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.hotel),
                  title: Text('Hotels'),
                  onTap: () {
                    Navigator.pushNamed(context, HotelsScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book_outlined),
                  title: Text('Trip Planner'),
                  onTap: () {
                    Navigator.pushNamed(context, TripScreen.id);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Auth().signOut();
                  },
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Information:'),
                  InformationList(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Tickets:'),
                  TicketsList(),
                                  SizedBox(
                    height: 10,
                  ),
                  Text('Trip Plans:'),
                  TripList(),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
//This class is to show the TicketList data
class TicketsList extends StatelessWidget {
  const TicketsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('ticket_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 200.0,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    return Card(
                      child: Container(
                        width: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  snapshot.data.documents[position]
                                      ['ticket_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  snapshot.data.documents[position]
                                      ['ticket_date'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  snapshot.data.documents[position]
                                      ['ticket_location'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Text(snapshot.data.documents[position]
                                    ['ticket_description']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }else{
          return Center(
            child: Container(
            child: Text('There is no data'),
        ),
          );
        }
      },
    );
  }
}

//This class is to show the InformationList data
class InformationList extends StatelessWidget {
  const InformationList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('information')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 250.0,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data.documents[position]['picURL'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 180,
                        child: Opacity(
                          opacity: 0.75,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0xFF000000)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      snapshot.data.documents[position]
                                          ['city_name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      snapshot.data.documents[position]
                                          ['country_name'],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      snapshot.data.documents[position]
                                          ['about'],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }
        return Container(
          child: Text('There is no data'),
        );
      },
    );
  }
}
//This class is to show the TripList data
class TripList extends StatelessWidget {
  const TripList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('trip')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 200.0,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                    return Card(
                      child: Container(
                        width: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  snapshot.data.documents[position]
                                      ['city_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  snapshot.data.documents[position]
                                      ['country_name'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Text(snapshot.data.documents[position]
                                    ['trip_plan']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }else{
          return Center(
            child: Container(
            child: Text('There is no data'),
        ),
          );
        }
      },
    );
  }
}