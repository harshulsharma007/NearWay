import 'package:flutter/material.dart';
import 'package:near_way/people/ChatDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleTab extends StatefulWidget {
  @override
  PeopleTabState createState() => new PeopleTabState();
}

class PeopleTabState extends State<PeopleTab> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            'People',
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 25.0),
          ),
          titleSpacing: 35.0,
          actions: <Widget>[
            RawMaterialButton(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              shape: CircleBorder(),
              elevation: 0.0,
              child: Icon(Icons.search, size: 25.0, color: Colors.black),
              onPressed: () {},
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child: ListTile(
                        leading:
                            new CircleAvatar(child: Text(document['name'][0])),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 4.0),
                        title: Text(document['name']),
                        subtitle: Text('message'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => chatDetail()));
                        },
                      ));
                }).toList());
            }
          },
        ) /*ChatListWidget(10, (value){
        Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return chatDetail(value);
            }));
      }),*/
        );
  }
}
