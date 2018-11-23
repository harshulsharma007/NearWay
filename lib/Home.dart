import 'package:flutter/material.dart';
import 'Home_Tab.dart';
import 'People_Tab.dart';
import 'chat.dart';
import 'Profile_Tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Places_Tab.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:near_way/AuthStore.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  String uid;
  bool isLoading = false;

  Future<void> handleUser() async {
    this.setState((){
      isLoading = true;
    });

    FirebaseUser currentuser = await FirebaseAuth.instance.currentUser();

    final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: currentuser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if(documents.length ==0 ) {
      Firestore.instance
          .collection('users')
          .document(currentuser.uid)
          .setData({
        'name' : currentuser.displayName,
        'photourl' : currentuser.photoUrl,
        'id' : currentuser.uid,
      });
    }
    setState(() {
      uid = currentuser.uid;
      isLoading = false;
      print("Waaaaaaaahhhhhhhhhhhhhhh");
    });
  }

  @override
  void initState() {
    super.initState();
    handleUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: isLoading ? Center(
          child: CircularProgressIndicator()
        ) :
        new DefaultTabController(
            length: 4,
            child: new Scaffold(
              bottomNavigationBar: Theme(
                data: ThemeData(
                  tabBarTheme: TabBarTheme(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                  splashColor: Colors.deepOrangeAccent,
                  brightness: Brightness.light,
                ),
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  tabs: <Widget>[
                    Tab(
                        icon: Icon(
                      Icons.home,
                      color: Colors.black54,
                      size: 25.0,
                    )),
                    Tab(
                        icon: Icon(Icons.people,
                            color: Colors.black54, size: 25.0)),
                    Tab(
                        icon: Icon(Icons.place,
                            color: Colors.black54, size: 25.0)),
                    Tab(
                        icon: Icon(Icons.account_circle,
                            color: Colors.black54, size: 25.0)),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  HomeTab(),
                  PeopleTab(),
                  PlacesTab(),
                  ProfileTab(uid : this.uid)
                ],
              ),
            )));
  }
}
