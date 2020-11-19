import 'package:flutter/material.dart';
import 'package:gosaudi/components/auth.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/my_custom_dialog.dart';
import 'package:gosaudi/components/rounded_button.dart';
import 'package:gosaudi/screens/registeration_screen.dart';
import 'package:gosaudi/screens/welcome_screen.dart';

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
  String email;
  String password;

  void validateForm() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        final user = Auth().signInWithEmail(email, password);
        if (user != null) {
          Navigator.popAndPushNamed(context, WelcomeScreen.id);
        }
        formKey.currentState.reset();
      } catch (e) {}
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
            height: 313,
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 230,
                        height: 42,
                        child: TextFormField(
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
                              labelText: 'Email:',
                              hintText: 'Enter Your Email'),
                        )),
                    Container(
                        width: 230,
                        height: 42,
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (value) =>
                              value.isEmpty ? 'Password cannot be empty' : null,
                          onSaved: (value) => password = value,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Enter your Password',
                              labelText: 'Password:'),
                        )),
                    RoundedButton(
                      onPressed: () {
                        validateForm();
                      },
                      title: 'Login',
                      color: Color(0xFF0F9A4F),
                    ),
                    Container(
                        width: 191,
                        height: 15,
                        child: Row(
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
                            ])),
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
}

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
