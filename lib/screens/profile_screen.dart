import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:gosaudi/components/custom_text_form_field.dart';
import 'package:gosaudi/components/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomContainer(
        body: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  
                  Container(
                    height: 128,
                    width: 128,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : LinearProgressIndicator(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          icon: Icon(Icons.camera_alt), onPressed: () {}))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 50,width: 50,child: Positioned(child: Text('Name'),top: 0,left: 1,)),
              ),
               Container(
                  height: 313,
                  width: 230,
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextFormField(
                          title: 'Name',
                        ),
                        CustomTextFormField(
                          title: 'Bio',
                        ),
                        CustomTextFormField(
                          title: 'Date of Birth',
                          inputType: TextInputType.datetime,
                        ),
                        CustomTextFormField(
                          title: 'Location',
                        ),
                      ],
                    ),
                  ),
                ),
            
              
            ],
          ),
        ),
      ),
    );
  }
}
