import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EditProfile',
      home: Scaffold(
        body: Center(
          child: Text('edit profile here'),
        ),
      ),
    );
  }
}
