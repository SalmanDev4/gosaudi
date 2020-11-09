import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name;
  String bio;
  String gender;
  String location;
  String dob;
  String documentId;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('usersProfile');
    return SafeArea(
      child: CustomContainer(
          body: StreamBuilder(
            stream: users.doc(_auth.currentUser.uid).snapshots(),
            builder:           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        // if (snapshot.connectionState == ConnectionState.done) {
        //   return getUsersData(snapshot);
        // }

        // return new ListView(children: getUsersData(snapshot),);
        // return new Text(snapshot.data.docs.map((e) => e['Name']).toList().toString());

        return new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : LinearProgressIndicator(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data.data()['name'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(snapshot.data.data()['bio']),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data.data()['gender']),
                              Text(snapshot.data.data()['location']),
                              Row(
                                children: [
                                  Text('Born in '),
                          Text(snapshot.data.data()['birth_date'])
                                ],
                              )
                          
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );


      },
            )
          ),
    );
  }

  getUsersData(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) => new ListTile(title: new Text(doc["Name"]),
    subtitle: new Text(doc["Bio"]),)).toList();
  }
}
