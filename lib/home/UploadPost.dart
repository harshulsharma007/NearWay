import 'package:flutter/material.dart';
import 'dart:io';

class PostDetails {
  File img;
  String placeName;
  String location;
  int score;
}

class UploadPage extends StatefulWidget {
  final File curPost;
  String _location;

  UploadPage({Key key, @required this.curPost}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UploadPageState();
  }
}

class UploadPageState extends State<UploadPage> {
  static void onShareButtonPress() {}

  static void _handleSubmitted(String value) {}

  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('New Post',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
            leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 28.0),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: <Widget>[
              new RawMaterialButton(
                child: Text(
                  'Share',
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: onShareButtonPress,
              )
            ],
          ),
          body: new Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            constraints: BoxConstraints.expand(),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new SizedBox(width: 5.0),
                    new Container(
                      padding: EdgeInsets.all(6.0),
                      height: 80.0,
                      width: 80.0,
                      child: InkWell(
                          child: Image.file(widget.curPost, fit: BoxFit.cover),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ImageView(widget.curPost)));
                          }),
                    ),
                    SizedBox(width: 5.0),
                    new Flexible(
                        child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write a caption..',
                      ),
                      onSubmitted: _handleSubmitted,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                    ))
                  ],
                ),
                new Divider(),
                new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Add Location'),
                    ),
                    new RawMaterialButton(
                      elevation: widget._location != null ? 7.0 : 0.5,
                      fillColor: widget._location != null
                          ? Colors.lightBlueAccent
                          : Colors.white,
                      child: widget._location != null
                          ? Container(
                              padding: EdgeInsets.all(2.0),
                              child: Text(widget._location),
                            )
                          : Container(),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class ImageView extends StatelessWidget {
  File _img;

  ImageView(this._img);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        constraints: BoxConstraints.expand(),
        child: Image.file(_img),
      ),
    );
  }
}
