import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gosaudi/components/auth.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';
import 'package:gosaudi/components/rounded_button.dart';
import 'package:gosaudi/screens/registeration_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

//This is the login screen where the user can loggedIn to the app.

final String screenName = 'Login';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _email;
  String _password;
  String _error;

// Validation of the form
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

// Submit the form if it's validate to loggedIn the user.
  void submitForm() async {
    if (validateForm()) {
      try {
        Auth().signInWithEmail(_email, _password);
        Navigator.popAndPushNamed(context, WelcomeScreen.id);
        
      } on FirebaseAuthException catch (e) {
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          EmailValidator.validate(value),
                      onSaved: (value) => _email = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          labelText: 'Email:',
                          hintText: 'Enter Your Email'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                          PasswordValidator.validate(value),
                      onSaved: (value) => _password = value,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          labelText: 'Password:'),
                    ),
                    RoundedButton(
                      onPressed: () {
                        submitForm();
                      },
                      title: 'Login',
                      color: Color(0xFF0F9A4F),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Don’t have account?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.popAndPushNamed(
                                context, RegisterationScreen.id),
                            child: Text(
                              'Register',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => ForgotPasswordDialog()),
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]),
            )),
      )),
    );
  }
// This widget is to show the alert if there is an error.
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

// This class for showing dialog of Forget password.
class ForgotPasswordDialog extends StatefulWidget {
  ForgotPasswordDialog({Key key}) : super(key: key);

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  String email;
  final _emailController = TextEditingController();

  void validateForm() async {
    final form = CustomDialog.formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        Auth().resetPassword(email);
      } catch (e) {
        print(e);
      }
      CustomDialog.formKey.currentState.reset();
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value.isEmpty ? 'Email cannot be empty' : null,
            onSaved: (value) => email = value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
            decoration: InputDecoration(
                labelText: 'Email:', hintText: 'Enter Your Email'),
          ),
          FlatButton(
            onPressed: () {
              validateForm();
              Navigator.pop(context);
            },
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
    );
  }
}
