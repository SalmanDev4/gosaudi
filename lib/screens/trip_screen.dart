import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:intl/intl.dart';

//This is the Trip planning screen

//This is the reference in the Firebase database
final CollectionReference _tripCollection = FirebaseFirestore.instance.collection('trip');
final String screenName = 'Trip Planner';

class TripScreen extends StatefulWidget {
  static String id = 'trip_screen';
 
  TripScreen({Key key}) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final _auth = FirebaseAuth.instance;
  String countryName;
  String cityName;
  String tripPlan;
  final _countyNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _aboutController = TextEditingController();

// VAlidate and submit the form
  void validateForm() async {
    final form = CustomDialog.formKey.currentState;
    if(_auth.currentUser == null){
      print('Please sign/register');
    }else {
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
      form.save();
      try {
        _tripCollection.doc().set(
          {
            'addBy' : _userEmail,
            'country_name' : countryName,
            'city_name' : cityName,
            'trip_plan' : tripPlan,
            'timestamp' : Timestamp.now()
          }
        );
      } catch (e) {
        print(e);
      }

      //Showing notification
      SnackBar(content: Text('Trip plan has been added!'));
      CustomDialog.formKey.currentState.reset();
    } else {
      print('Form is invalid');
    }
    }}
    
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomContainer(
        title: Text(screenName),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
        TripStream(),
                ],
              ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_auth.currentUser != null){
            showDialog(context: context,
            builder: (context) => CustomDialog(
              child: Column(
                children: [
                  TextFormField(
                    controller: _countyNameController,
                    onSaved: (newValue) => countryName = newValue,
                    decoration: InputDecoration(labelText: 'Country:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Country' : null,
                            maxLength: 60,
                  ),
                  TextFormField(
                    controller: _cityNameController,
                    onSaved: (newValue) => cityName = newValue,
                    decoration: InputDecoration(labelText: 'City:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a City' : null,
                            maxLength: 60,
                  ),
                  TextFormField(
                    controller: _aboutController,
                    onSaved: (newValue) => tripPlan = newValue,
                    decoration: InputDecoration(labelText: 'Trip Plan:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Trip Plan' : null,
                            maxLength: 300,
                  ),
                  FlatButton(
                        onPressed: () {
                          validateForm();
                          Navigator.pop(context);
                        },
                        child: Text('Submit',style: TextStyle(color: Colors.green),),
                      )
                  
                ],
              ), 
              width: MediaQuery.of(context).size.width / 1.2, 
              height: MediaQuery.of(context).size.height / 1.8
              ),
            );
            }else{
            Navigator.pushNamed(context, LoginScreen.id);
          }
          },
          child: Icon(Icons.add),
          ),
      ),
    );
  }
}

// This to get data from Firebase database.
class TripStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _tripCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot){
    if (!snapshot.hasData){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
      final informationData = snapshot.data.documents;
    List<TripCard> informationCards = [];
    for (var data in informationData) {
      final country = data.data()['country_name'];
      final city = data.data()["city_name"];
      final tripPlan= data.data()["trip_plan"];
      final timestamp = data.data()["timestamp"];
      final addBy = data.data()["addBy"];

      final informationCard = TripCard(
        countryName: country,
        cityName: city,
        tripPlan: tripPlan,
        timestamp: timestamp,
        addBy: addBy,
      );
      informationCards.add(informationCard); 
    }
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.00),
        children: informationCards,
      ),
    );
        },
      );
  }
}

//Representing data in Card widget.
class TripCard extends StatelessWidget {
TripCard({this.countryName,this.tripPlan,this.cityName,this.timestamp,this.addBy});

final String countryName;
final String cityName;
final String tripPlan;
final Timestamp timestamp;
final String addBy;



  @override
  Widget build(BuildContext context) {
    DateTime now = timestamp.toDate();
return Container(
      height: 350,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: 
               Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ 
                          Text('Contact: $addBy',style: TextStyle(color: Colors.indigoAccent),),
                          Text(DateFormat.yMMMMd().add_jm().format(now)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                          Text('Country: $countryName'),
                          Text('City: $cityName'),
                            ],
                          ),
                          
                          Flexible(flex: 3,child: Text.rich(TextSpan(text: tripPlan))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            
          ),
        ),
      
    );}
}