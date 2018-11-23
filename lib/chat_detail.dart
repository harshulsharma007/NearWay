import 'package:flutter/material.dart';
import 'chat_message.dart';

class chatDetail extends StatefulWidget
{
  final int data;

  chatDetail(this.data);

  @override
  chatDetailState createState() => new chatDetailState();
}

class chatDetailState extends State<chatDetail>
{
  final TextEditingController _textEditingController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  void _handleSubmitted(String text)
  {
    _textEditingController.clear();

    ChatMessage message = new ChatMessage(
        text: text
    );

    setState(() {
      _messages.insert(_messages.length,message);
    });
  }

  Widget _textComposerWidget(){
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
                  decoration: InputDecoration(hintText: 'message...',
                      border: OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(18.0))),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)
                  ),
                  onSubmitted: _handleSubmitted,
                  maxLines: null,
                  textInputAction: TextInputAction.continueAction,
                  textCapitalization: TextCapitalization.sentences,

                ),
              ),

              new Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(icon: Icon(Icons.send), onPressed: () => _handleSubmitted(_textEditingController.text)),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, int index)=> _messages[index],
            itemCount: _messages.length,
          ),
        ),

        new Divider(height: 1.0),

        new Container(
          child: _textComposerWidget(),
        )
      ],
    );
  }

}