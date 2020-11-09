import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';

final _firestore = FirebaseFirestore.instance;

class TicketsScreen extends StatefulWidget {
  static String id = 'tickets_screen';
  TicketsScreen({Key key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final _auth = FirebaseAuth.instance;

  CollectionReference ticketsCollection = FirebaseFirestore.instance.collection('tickets');
  
  String eventName;
  String eventDescreption;
  String eventDate;
  String eventLocation;
  int ticketsNum;
  final _eventNameController = TextEditingController();
  final _eventDescreptionController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _ticketsNumController = TextEditingController();

  void validateForm() async {
    final form = CustomDialog.formKey.currentState;
    if(_auth.currentUser == null){
      print('Please sign/register');
    }else {
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
      form.save();
      try {
        FirebaseFirestore.instance.collection("tickets").doc().set(
          {
            'addBy' : _userEmail,
            'event_name' : eventName,
            'event_descreption' : eventDescreption,
            'event_location' : eventLocation,
            'event_date' : eventDate,
            'ticketsNum' : ticketsNum
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
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
        TicketsStream(),
                ],
              ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context,
            builder: (context) => CustomDialog(
              child: Column(
                children: [
                  TextFormField(
                    controller: _eventNameController,
                    onSaved: (newValue) => eventName = newValue,
                    decoration: InputDecoration(labelText: 'Event Name:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter an Event Name' : null,
                            maxLength: 60,
                  ),
                  TextFormField(
                    controller: _eventDescreptionController,
                    onSaved: (newValue) => eventDescreption = newValue,
                    decoration: InputDecoration(labelText: 'Event Descreption:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter an Event Descreption' : null,
                            maxLength: 200,
                  ),
                  TextFormField(
                    controller: _eventDateController,
                    onSaved: (newValue) => eventDate = newValue,
                    decoration: InputDecoration(labelText: 'Event Date/Time:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter an Event DAte/Time' : null,
                            keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _eventLocationController,
                    onSaved: (newValue) => eventLocation = newValue,
                    decoration: InputDecoration(labelText: 'Event Location:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter an Event Location' : null,
                            maxLength: 60,
                            keyboardType: TextInputType.streetAddress,
                  ),
                  TextFormField(
                    controller: _ticketsNumController,
                    onSaved: (newValue) => ticketsNum = int.parse(newValue),
                    decoration: InputDecoration(labelText: 'Tickets Numbers:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Tickets Numbers' : null,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
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
            
          },
          child: Icon(Icons.add),
          ),
      ),
    );
  }
}

class TicketsStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('tickets').orderBy('event_date', descending: true).snapshots(),
        builder: (context, snapshot){
    if (!snapshot.hasData){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
      final tickets = snapshot.data.documents;
    List<EventCard> eventCards = [];
    for (var ticket in tickets) {
      final eventName = ticket.data()['event_name'];
      final eventDate = ticket.data()["event_date"];
      final eventDescreption= ticket.data()["event_descreption"];
      final eventLocation = ticket.data()["event_location"];
      final ticketNum = ticket.data()["ticketsNum"];

      final eventCard = EventCard(
        eventName: eventName,
        eventDate: eventDate,
        eventDescreption: eventDescreption,
        eventLocation: eventLocation,
        ticketNum: ticketNum,
      );
      eventCards.add(eventCard); 
    }
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.00),
        children: eventCards,
      ),
    );
        },
      );
  }
}

class EventCard extends StatelessWidget {
EventCard({this.eventDate,this.eventDescreption,this.eventLocation,this.eventName,this.ticketNum});

final String eventName;
final String eventDate;
final String eventDescreption;
final String eventLocation;
final int ticketNum;


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
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Image.network(
                                  'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : LinearProgressIndicator(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(eventName),
                              Text(eventDate),
                              
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(eventDescreption),
                                Text(eventLocation),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                                                  child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text('Remaining Tickets: $ticketNum',style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
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


