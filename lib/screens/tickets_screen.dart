import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';

// This is the Ticcketing screen

//This to get reference of ticket in the Firebase.
final CollectionReference _ticketsCollection = FirebaseFirestore.instance.collection('tickets');
final String screenName = 'Tickets';

class TicketsScreen extends StatefulWidget {
  static String id = 'tickets_screen';
  TicketsScreen({Key key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final _auth = FirebaseAuth.instance;
  
  String _ticketName;
  String _ticketDescription;
  String _ticketDate;
  String _ticketLocation;
  int _ticketsNum;
  final _ticketNameController = TextEditingController();
  final _ticketDescreptionController = TextEditingController();
  final _ticketDateController = TextEditingController();
  final _ticketLocationController = TextEditingController();
  final _ticketsNumController = TextEditingController();

// Valifation Form, submit if the data is valid.
  void validateForm() async {
    final form = CustomDialog.formKey.currentState;
    if(_auth.currentUser == null){
      print('Please sign/register');
    }else {
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
      form.save();
      try {
        _ticketsCollection.doc().set(
          {
            'addBy' : _userEmail,
            'ticket_name' : _ticketName,
            'ticket_description' : _ticketDescription,
            'ticket_location' : _ticketLocation,
            'ticket_date' : _ticketDate,
            'ticketsNum' : _ticketsNum
          }
        );
      } catch (e) {
        print(e);
      }
      CustomDialog.formKey.currentState.reset();

      // Showing notification
      SnackBar(content: Text('Ticket has been added!'));
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
                    controller: _ticketNameController,
                    onSaved: (newValue) => _ticketName = newValue,
                    decoration: InputDecoration(labelText: 'Ticket Name:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Ticket Name' : null,
                            maxLength: 60,
                  ),
                  TextFormField(
                    controller: _ticketDescreptionController,
                    onSaved: (newValue) => _ticketDescription = newValue,
                    decoration: InputDecoration(labelText: 'Ticket Descreption:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Ticket Descreption' : null,
                            maxLength: 200,
                  ),
                  TextFormField(
                    controller: _ticketDateController,
                    onSaved: (newValue) => _ticketDate = newValue,
                    decoration: InputDecoration(labelText: 'Ticket Date/Time:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Ticket Date/Time' : null,
                            keyboardType: TextInputType.datetime,
                  ),
                  TextFormField(
                    controller: _ticketLocationController,
                    onSaved: (newValue) => _ticketLocation = newValue,
                    decoration: InputDecoration(labelText: 'Ticket Location:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter an Ticket Location' : null,
                            maxLength: 60,
                            keyboardType: TextInputType.streetAddress,
                  ),
                  TextFormField(
                    controller: _ticketsNumController,
                    onSaved: (newValue) => _ticketsNum = int.parse(newValue),
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

// This stream to get data from Firebase database.
class TicketsStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _ticketsCollection.orderBy('ticket_date', descending: true).snapshots(),
        builder: (context, snapshot){
    if (!snapshot.hasData){
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
      final tickets = snapshot.data.documents;
    List<TicketCard> ticketsCards = [];
    for (var ticket in tickets) {
      final ticketName = ticket.data()['ticket_name'];
      final ticketDate = ticket.data()["ticket_date"];
      final ticketDescription= ticket.data()["ticket_description"];
      final ticketLocation = ticket.data()["ticket_location"];
      final ticketNum = ticket.data()["ticketsNum"];
      final addBy = ticket.data()["addBy"];

      final ticketCard = TicketCard(
        ticketName: ticketName,
        ticketDate: ticketDate,
        ticketDescription: ticketDescription,
        ticketLocation: ticketLocation,
        ticketNum: ticketNum,
        addBy: addBy,
      );
      ticketsCards.add(ticketCard); 
    }
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.00),
        children: ticketsCards,
      ),
    );
        },
      );
  }
}

//This calss to represent the data in Card widget.
class TicketCard extends StatelessWidget {
TicketCard({this.ticketDate,this.ticketDescription,this.ticketLocation,this.ticketName,this.ticketNum,this.addBy});

final String ticketName;
final String ticketDate;
final String ticketDescription;
final String ticketLocation;
final int ticketNum;
final String addBy;


  @override
  Widget build(BuildContext context) {
return Container(
      height: 350,
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
                              Text(ticketName),
                              Text(ticketDate),
                              
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(ticketDescription),
                                Text(ticketLocation),
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
                        Flexible(
                          flex: 1,
                                                  child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text('Contact: $addBy',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent
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


