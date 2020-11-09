import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  static final formKey = new GlobalKey<FormState>();
  
  CustomDialog({Key key, @required this.child, @required this.width, @required this.height}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: CustomDialog.formKey,
                  child: widget.child,
                ),
              ),
            ),
          );
  }
}