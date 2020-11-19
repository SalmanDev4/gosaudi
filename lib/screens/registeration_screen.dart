import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gosaudi/components/auth.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/rounded_button.dart';
import 'package:gosaudi/screens/login_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

//This is the registeration screen.

final String screenName = 'Register';

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
  String _email;
  String _password;
  String _error;

// Validation Form
bool validateForm(){
  final form = formKey.currentState;
  form.save();
  if(form.validate()){
    form.save();
    return true;
  }else{
    return false;
  }
}

//Submit the form if it's validate
  void submitForm() async {
    if (validateForm()) {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (newUser != null) {
          //show dialog to complete the user profile data.
          showDialog(
            context: context,
            builder: (context) => MyDialog(),
          );
        }
      } on FirebaseAuthException catch(e) {
        setState(() {
          _error = e.message;
        });
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
        title: Text(screenName),
        body: Center(
          child: Container(
            width: 230,
            height: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  showAlert(),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) => EmailValidator.validate(value),
                    onSaved: (newValue) => _email = newValue,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Email:',
                        hintText: 'Enter your email address'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) => PasswordValidator.validate(value),
                    onSaved: (newValue) => _password = newValue,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Password:',
                        hintText: 'Enter your password'),
                  ),
                  RoundedButton(
                    onPressed: () async {
                      submitForm();
                    },
                    title: 'Register',
                    color: Color(0xFF0F9A4F),
                  ),
                  Container(
                    width: 191,
                    height: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Already have an account?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, LoginScreen.id);
                          },
                          child: Text(
                            'Login',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget showAlert(){
    if(_error !=null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child:Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(child: Text(_error)),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: IconButton(icon: Icon(Icons.close), onPressed: (){
                setState(() {
                  _error = null;
                });
              }),
            )
          ],
        )
      );
    }
    return SizedBox(height: 0,);
  }
}

//Implementation of the dialog
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
    if (_auth.currentUser == null) {
      print('Please sign/register');
    } else {
      String _userID = _auth.currentUser.uid;
      String _userEmail = _auth.currentUser.email;
      if (form.validate()) {
        form.save();
        try {
          FirebaseFirestore.instance
              .collection("usersProfile")
              .doc(_userID)
              .set({
            'email': _userEmail,
            'name': _name,
            'bio': _bio,
            'birth_date': _birthDate,
            'location': _location,
            'gender': _selectedRadio
          });
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
                  validator: (value) =>
                      value.isEmpty ? 'You should enter a Birth Date' : null,
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
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
