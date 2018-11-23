import 'package:flutter/material.dart';

var imageurl =
    'https://images.pexels.com/photos/41008/cowboy-ronald-reagan-cowboy-hat-hat-41008.jpeg?auto=compress&cs=tinysrgb&h=650&w=940';
bool temp = false;

class Post extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostState();
  }
}

class PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
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
              Text(
                'username',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Image(
            image: NetworkImage(imageurl),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(3.0),
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
              Text(
                '25 likes',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
