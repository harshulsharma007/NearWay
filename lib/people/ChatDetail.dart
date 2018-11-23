import 'package:flutter/material.dart';
import 'package:near_way/people/ChatMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Chat extends StatelessWidget {

  final String peerName;
  final String peerId;
  final String peerAvatar;

  Chat({Key key, @required this.peerName, @required this.peerId, @required this.peerAvatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(peerName),
        centerTitle: true,
      ),
      body: ChatScreen(peerId: peerId, peerAvatar: peerAvatar),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar}) : super(key: key);

  @override
  ChatScreenState createState() => new ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;
  var listmessage;
  String ChatId;
  bool isLoading;

  final TextEditingController _textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  //final List<ChatMessage> _messages = <ChatMessage>[];

  @override
  void initState(){
    super.initState();

    ChatId = '';
    isLoading = false;

    readLocal();
  }

  readLocal() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user!=null){
      id = user.uid;
    }
    if(id.hashCode <= peerId.hashCode){
      ChatId = '$id-$peerId';
    } else {
      ChatId = '$peerId-$id';
    }
    setState(() {});
  }

  void onSendMessage(String content){

    if(content.trim() != '') {
      _textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(ChatId)
          .collection(ChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom' : id,
            'idTo' : peerId,
            'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
            'content' : content
          },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  /*void _handleSubmitted(String text) {
    _textEditingController.clear();

    ChatMessage message = new ChatMessage(text: text);

    setState(() {
      _messages.insert(_messages.length, message);
    });
  }*/

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
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Material(
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: (){ onSendMessage(_textEditingController.text );},
                    color: Color(0xff203152)
                  ),
                ),
              )
            ],
          ),
        ));
  }

  bool isLastMessageRight(int index){
    if((index > 0 && listmessage!=null && listmessage[index-1]['idFrom'] != id) || index == 0){
      return true;
    }else {
      return false;
    }
  }

  bool isLastMessageLeft(int index){
    if((index > 0 && listmessage!=null && listmessage[index-1]['idFrom'] == id) || index == 0){
      return true;
    }else {
      return false;
    }
  }

  Widget buildItem(int index, DocumentSnapshot document){
    if(document['idFrom']==id){
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
                    imageUrl: peerAvatar,
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
            ),

            isLastMessageLeft(index)
              ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left:50.0, top:5.0, bottom:5.0),
            )
                :
                Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildListMessage(){
    return Flexible(
      child: ChatId==''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
              ),
      ):
          StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document(ChatId)
                .collection(ChatId)
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                  ),
                );
              } else {
                listmessage = snapshot.data.documents;
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      return buildItem(index, snapshot.data.documents[index]);
                    },
                    itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: listScrollController,
                );
              }
            },
          )
    );
  }

  Widget buildLoading(){
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[

            buildListMessage(),

            _textComposerWidget(),
          ],
        ),

        buildLoading()
      ],
    );
  }
}
