import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({@required this.title, this.inputType,this.controller});
  
  final String title;
  final TextInputType inputType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
    width: 230,
    height: 42,
    child: Stack(children: <Widget>[
      TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) =>
    value.isEmpty ? '$title cannot be empty' : null,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        decoration:
    InputDecoration(hintText: 'Enter your $title'),
      ),
      Positioned(
          top: 0,
          left: 0,
          child: Text(
    '$title:',
    textAlign: TextAlign.left,
    style: TextStyle(
        color: Color.fromRGBO(0, 0, 0, 1),
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1),
          )),
    ]));
  }
}