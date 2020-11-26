import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

// This is the Information Screen

// Reference of information in FireBase Database
final CollectionReference _informationCollection = FirebaseFirestore.instance.collection('information');
final String screenName = 'Information';

class InformationScreen extends StatefulWidget {
    static String id = 'information_screen';
  InformationScreen({Key key}) : super(key: key);

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _auth = FirebaseAuth.instance;
  String countryName;
  String cityName;
  String about;
  String picURL = "test";
  double rate;
  final _countyNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _picURLController = TextEditingController();

// Validate and submit the form
  void validateForm() async {
    final form = CustomDialog.formKey.currentState;
    if(_auth.currentUser == null){
      print('Please sign/register');
    }else {
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
      form.save();
      try {
        _informationCollection.doc().set(
          {
            'addBy' : _userEmail,
            'country_name' : countryName,
            'city_name' : cityName,
            'about' : about,
            'picURL' : picURL,
            'rating' : rate,
            'timestamp' : Timestamp.now()
          }
        );
      } catch (e) {
        print(e);
      }
      CustomDialog.formKey.currentState.reset();
      SnackBar(content: Text('Information has been added!'));
    } else {
      print('Form is invalid');
    }
    }
    
  }
  
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
        InformationStream(),
                ],
              ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_auth.currentUser != null){
            showDialog(context: context,
            builder: (context) => CustomDialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    onSaved: (newValue) => about = newValue,
                    decoration: InputDecoration(labelText: 'About:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a data about the city' : null,
                            maxLength: 300,
                            maxLines: 3,
                  ),
                  TextFormField(
                    controller: _picURLController,
                    onSaved: (newValue) => picURL = newValue,
                    decoration: InputDecoration(labelText: 'Picture URL:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a URL of the Picture' : null,
                  ),
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (rating) {
                      rate=rating;
                    },
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
              height: MediaQuery.of(context).size.height / 1.5
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

// Get data from Firebase database
class InformationStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _informationCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot){
    if (!snapshot.hasData){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
      final informationData = snapshot.data.documents;
    List<InformationCard> informationCards = [];
    for (var data in informationData) {
      final country = data.data()['country_name'];
      final city = data.data()["city_name"];
      final about= data.data()["about"];
      final timestamp = data.data()["timestamp"];
      final picURL = data.data()["picURL"];
      final rating = data.data()["rating"];

      final informationCard = InformationCard(
        countryName: country,
        cityName: city,
        about: about,
        timestamp: timestamp,
        picURL: picURL,
        rating: rating.toDouble(),
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

// Representing data using Card Widget.
class InformationCard extends StatelessWidget {
InformationCard({this.countryName,this.about,this.cityName,this.picURL,this.timestamp,this.rating});

final String countryName;
final String cityName;
final String about;
final String picURL;
final Timestamp timestamp;
final dynamic rating;


  @override
  Widget build(BuildContext context) {
return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: 
               Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Image.network(
                                  picURL,
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : LinearProgressIndicator(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SmoothStarRating(
                                  allowHalfRating: false,
                                  isReadOnly: true,
                                  rating: rating.toDouble(),
                                ),
                                Text(countryName),
                                Text(cityName),
                                Text(about),
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            
          ),
        ),
      
    );}
}