import 'package:flutter/material.dart';
import 'chat_detail.dart';


typedef Null ItemSelectedCallback(int value);

class ChatListWidget extends StatefulWidget
{
  final int count;
  final ItemSelectedCallback onItemSelected;

  ChatListWidget(this.count, this.onItemSelected);

  @override
  _ChatListWidgetState createState() => new _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget>
{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.count,
      itemBuilder: (context, int position){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: ListTile(
            leading: new CircleAvatar(child: Text('A')),
            contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            title: Text('name'),
            subtitle: Text('message'),
            onTap: (){
              widget.onItemSelected(position);
            },
          )
        );
      },
    );
  }
}

