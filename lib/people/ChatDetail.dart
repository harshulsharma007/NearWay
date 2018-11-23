import 'package:flutter/material.dart';
import 'package:near_way/people/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class chatDetail extends StatefulWidget {
  @override
  chatDetailState createState() => new chatDetailState();
}

class chatDetailState extends State<chatDetail> {

  String userid;
  var listmessage;

  final TextEditingController _textEditingController =
      new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text) {
    _textEditingController.clear();

    ChatMessage message = new ChatMessage(text: text);

    setState(() {
      _messages.insert(_messages.length, message);
    });
  }

  Widget _textComposerWidget() {
    return IconTheme(
        data: IconThemeData(color: Colors.grey),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Flexible(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: 'message...',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius:
                              BorderRadius.all(Radius.circular(18.0))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)),
                  onSubmitted: _handleSubmitted,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () =>
                        _handleSubmitted(_textEditingController.text)),
              )
            ],
          ),
        ));
  }

  bool isLastMessageRight(int index){
    if((index > 0 && listmessage!=null && listmessage[index-1]['id'] != userid) || index == 0){
      return true;
    }else {
      return false;
    }
  }

  bool isLastMessageLeft(int index){
    if((index > 0 && listmessage!=null && listmessage[index-1]['id'] == userid) || index == 0){
      return true;
    }else {
      return false;
    }
  }

  Widget buildItem(int index, DocumentSnapshot document){
    if(document['id']==userid){
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
              color: Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(8.0)
            ),
            margin: EdgeInsets.only(
              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
              right: 10.0
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
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
                    imageUrl: imageurl,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0)
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    :
                    Container(width: 35.0),

                Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color:Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Color(0xff203152),
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )

              ],
            )
          ],
        ),
      )
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            child: _textComposerWidget(),
          )
        ],
      ),
    );
  }
}
