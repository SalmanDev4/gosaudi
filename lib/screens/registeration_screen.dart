import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/rounded_button.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

class RegisterationScreen extends StatefulWidget {
  static String id = 'registeration_screen';
  RegisterationScreen({Key key}) : super(key: key);

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _auth = FirebaseAuth.instance;

  final formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String email;
  String password;


  void validateForm() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (newUser != null) {
          showDialog(context: context,builder: (context) => MyDialog(),);
        }
      } catch (e) {
        print(e);
      }
      formKey.currentState.reset();
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomContainer(
          body: Center(
        child: Container(
            width: 230,
            height: 313,
            child: Form(
              key: formKey,
              child: Stack(children: <Widget>[
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                        width: 230,
                        height: 42,
                        child: Stack(children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value.isEmpty ? 'Email cannot be empty' : null,
                            onSaved: (value) => email = value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration:
                                InputDecoration(hintText: 'Enter your Email'),
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Text(
                                'Email:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                        ]))),
                Positioned(
                    top: 73,
                    left: 0,
                    child: Container(
                        width: 230,
                        height: 42,
                        child: Stack(children: <Widget>[
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) => value.isEmpty
                                ? 'Password cannot be empty'
                                : null,
                            onSaved: (value) => password = value,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                                hintText: 'Enter your Password'),
                          ),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Text(
                                'Password:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                        ]))),
                Positioned(
                    top: 167,
                    left: 40,
                    child: RoundedButton(
                      onPressed: () async {
                        validateForm();
                        
                      },
                      title: 'Register',
                      color: Color(0xFF0F9A4F),
                    )),
                Positioned(
                    top: 298,
                    left: 20,
                    child: Container(
                        width: 191,
                        height: 15,
                        child: Stack(children: <Widget>[
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Text(
                                'Already have an account?',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                          Positioned(
                              top: 0,
                              left: 138,
                              child: GestureDetector(
                                // onTap: () => Navigator.popAndPushNamed(
                                //     context, LoginScreen.id),
                                onTap: () {
                                  Navigator.popAndPushNamed(context, LoginScreen.id);
                                },
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              )),
                        ]))),
              ]),
            )),
      )),
    );
  }
}

class MyDialog extends StatefulWidget {
  MyDialog({Key key}) : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _auth = FirebaseAuth.instance;

  final _formKey = new GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _locationController = TextEditingController();
  String _name;
  String _bio;
  String _birthDate;
  String _location;
  String _selectedRadio;

  void _validateForm() async {
    final form = _formKey.currentState;
    if(_auth.currentUser == null){
      print('Please sign/register');
    }else {
      String _userID = _auth.currentUser.uid;
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
      form.save();
      try {
        FirebaseFirestore.instance.collection("usersProfile").doc(_userID).set(
          {
            'email' : _userEmail,
            'name' : _name,
            'bio' : _bio,
            'birth_date' : _birthDate,
            'location' : _location,
            'gender' : _selectedRadio
          }
        );
      } catch (e) {
        print(e);
      }
      _formKey.currentState.reset();
    } else {
      print('Form is invalid');
    }
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name:'),
                        validator: (value) =>
                            value.isEmpty ? 'You should enter a Name' : null,
                            onSaved: (newValue) => _name = newValue,
                        maxLength: 20,
                      ),
                      TextFormField(
                        controller: _bioController,
                        decoration: InputDecoration(labelText: 'Bio:'),
                        validator: (value) => value.isEmpty
                            ? 'You should enter a Bio that describe you'
                            : null,
                            onSaved: (newValue) => _bio = newValue,
                        maxLength: 160,
                      ),
                      TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(labelText: 'Birth Date:'),
                        validator: (value) => value.isEmpty
                            ? 'You should enter a Birth Date'
                            : null,
                            onSaved: (newValue) => _birthDate = newValue,
                        keyboardType: TextInputType.datetime,
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(labelText: 'Location:'),
                        validator: (value) => value.isEmpty
                            ? 'You should enter a valid Location'
                            : null,
                            onSaved: (newValue) => _location = newValue,
                        keyboardType: TextInputType.streetAddress,
                        maxLength: 50,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: _selectedRadio,
                            onChanged: (val) {
                              print('$val is selected');
                              setState(() {
                                _selectedRadio = val;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Text('Male'),
                          Radio(
                            value: 'Female',
                            groupValue: _selectedRadio,
                            onChanged: (val) {
                              print('$val is selected');
                              setState(() {
                                _selectedRadio = val;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Text('Female'),
                        ],
                      ),
                      FlatButton(
                        onPressed: () {
                          _validateForm();
                          Navigator.popAndPushNamed(context, WelcomeScreen.id);
                        },
                        child: Text('Submit',style: TextStyle(color: Colors.green),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}