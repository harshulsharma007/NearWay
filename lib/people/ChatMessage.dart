import 'package:flutter/material.dart';

const String name = "Harshul";

class ChatMessage extends StatelessWidget {
  final String text;

  ChatMessage({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: Text(name[0]))),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name, style: Theme.of(context).textTheme.subhead),
              SizedBox(height: 2.0),
              new Container(
                child: new Text(text),
              )
            ],
          )
        ],
      ),
    );
  }
}
