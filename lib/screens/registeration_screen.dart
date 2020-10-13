import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/rounded_button.dart';
import 'package:gosaudi/screens/login_screen.dart';

class RegisterationScreen extends StatefulWidget {
  static String id = 'registeration_screen';
  RegisterationScreen({Key key}) : super(key: key);

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final formKey = new GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String email;
  String password;

  void validateForm() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print(email);
      print(password);
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
                      onPressed: () {
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
                          onTap: () => Navigator.popAndPushNamed(context, LoginScreen.id),
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