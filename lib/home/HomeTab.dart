import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'UploadPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

var imageurl =
    'https://images.pexels.com/photos/41008/cowboy-ronald-reagan-cowboy-hat-hat-41008.jpeg?auto=compress&cs=tinysrgb&h=650&w=940';
bool temp = false;

class HomeTab extends StatefulWidget {
  @override
  HomeTabState createState() => new HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  File _image;
  bool isLoading = false;


  void onImageButtonPressed() async {
    print('picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      _image = img;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UploadPage(curPost: _image)));
    }
  }

  Widget buildPost(DocumentSnapshot document) {
    final bool alreadyLiked = temp;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: .2),
      ),
      width: MediaQueryData().size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageurl),
                  radius: 20.0,
                ),
              ),
              Text('username', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              )
            ],
          ),

          Image(
              image: NetworkImage(imageurl)
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2.0),
                child: IconButton(
                    icon: Icon(
                      alreadyLiked ? Icons.favorite : Icons.favorite_border,
                      color: alreadyLiked ? Colors.red : null,
                      size: 30.0,
                    ),
                    onPressed: () {
                      setState(() {
                        if (alreadyLiked) {
                          temp = false;
                        } else {
                          temp = true;
                        }
                      });
                    }),
              ),
              Text('25 likes', style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text('Captions captions Captions Captions Captions Captions Captions Captions'),
          )

        ],
      ),
    );
  }


  Widget buildLoading() {
    return Positioned(
        child: isLoading ?
        Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
            ),
          ),
          color:  Colors.white.withOpacity(0.8),
        ):
        Container()
    );
  }

  Widget buildListPosts(){
    return StreamBuilder(
      stream: Firestore.instance.collection('posts').document().snapshots(),
      builder: (context, snapshots) {
        if(!snapshots.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
            ),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return buildPost(snapshots.data.document[index]);
            },
            itemCount: snapshots.data.document.length,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.camera, size: 25.0, color: Colors.black54),
              onPressed: () {
                onImageButtonPressed();
              }),
          title: Text(
            'Nearway',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 25.0,
                color: Colors.black),
          ),
          actions: <Widget>[
            RawMaterialButton(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              shape: CircleBorder(),
              elevation: 0.0,
              child: Icon(Icons.message, size: 25.0, color: Colors.black),
              onPressed: () {},
            )
          ],
        ),
        floatingActionButton: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.deepOrangeAccent,
          padding: EdgeInsets.all(5.0),
          elevation: 2,
          splashColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            size: 33.0,
            color: Colors.white,
          ),
          onPressed: () async {
            File img = await ImagePicker.pickImage(source: ImageSource.gallery);
            if (img != null) {
              _image = img;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadPage(curPost: _image)));
            }
          },
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: buildListPosts()
            ),
          ]
        ),
    );
  }
}
