import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'UploadPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

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

  void onPressLike(String timestampid, bool alreadyliked, int likes){
    var documentReference = Firestore.instance
        .collection('posts')
        .document('RH3X62bQw4lMYZwmLJTM').updateData({
      'likes' : alreadyliked ? likes-1 : likes+1
    }
    );

    temp = !temp;
  }

  Widget buildPost(DocumentSnapshot document) {
    final bool alreadyLiked = temp;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: .2),
      ),
      width: MediaQueryData().size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: document['user_image'],
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(18.0)
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
              ),

              Text(document['name'], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              )
            ],
          ),

          Image(
              image: NetworkImage(document['photo_url'])
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
                      size: 28.0,
                    ),
                    onPressed: () {
                      onPressLike(document['timestamp'], alreadyLiked, document['likes']);
                      setState(() {});
                    }),
              ),
              Text( document['likes'].toString() + ' likes' , style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(document['place'], style: TextStyle(fontWeight: FontWeight.bold))
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 2.0),
            child: Text(document['caption']),
          ),

          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
              style: TextStyle(color: Color(0xffaeaeae), fontSize: 12.0, fontStyle: FontStyle.italic),
            ),
            margin: EdgeInsets.only(left:20.0, top:5.0, bottom:5.0),
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
      stream: Firestore.instance.collection('posts').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
            ),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return buildPost(snapshot.data.documents[index]);
            },
            itemCount: snapshot.data.documents.length,
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
