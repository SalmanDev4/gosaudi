import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';
import 'package:gosaudi/screens/login_screen.dart';


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
  final _countyNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _aboutController = TextEditingController();
    final _picURLController = TextEditingController();

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
            'timestamp' : Timestamp.now()
          }
        );
      } catch (e) {
        print(e);
      }
      CustomDialog.formKey.currentState.reset();
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
                  ),
                  TextFormField(
                    controller: _picURLController,
                    onSaved: (newValue) => picURL = newValue,
                    decoration: InputDecoration(labelText: 'Picture URL:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a URL of the Picture' : null,
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

      final informationCard = InformationCard(
        countryName: country,
        cityName: city,
        about: about,
        timestamp: timestamp,
        picURL: picURL,
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

class InformationCard extends StatelessWidget {
InformationCard({this.countryName,this.about,this.cityName,this.picURL,this.timestamp});

final String countryName;
final String cityName;
final String about;
final String picURL;
final Timestamp timestamp;


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