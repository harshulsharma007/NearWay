import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'UploadPost.dart';
import 'CardView.dart';

class HomeTab extends StatefulWidget
{
  @override
  HomeTabState createState() => new HomeTabState();
}

class HomeTabState extends State<HomeTab>
{
  File _image;

  void onImageButtonPressed() async {
    print('picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if(img!=null){
      _image = img;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPage(curPost: _image)));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(Icons.camera, size:25.0, color: Colors.black54), onPressed: (){onImageButtonPressed();}),
          title: Text('Nearway', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25.0, color: Colors.black),),
          actions: <Widget>[
            RawMaterialButton(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              shape: CircleBorder(),
              elevation: 0.0,
              child: Icon(Icons.message, size: 25.0,color: Colors.black),
              onPressed: (){},
            )
          ],
        ),

        floatingActionButton: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.deepOrangeAccent,
          padding: EdgeInsets.all(5.0),
          elevation: 2,
          splashColor: Colors.deepOrange,
          child: Icon(Icons.add, size:33.0,color: Colors.white,),
          onPressed: () async{
            File img = await ImagePicker.pickImage(source: ImageSource.gallery);
            if(img!=null){
              _image = img;
              Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage(curPost: _image)));
            }
          },
        ),

        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, int index){
            return Post();
          },

        )
    );
  }
}