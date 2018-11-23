import 'package:flutter/material.dart';
import 'package:near_way/AuthStore.dart';
import 'package:near_way/EditProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';


class ProfileTab extends StatefulWidget
{
  final String uid;
  ProfileTab({Key key, @required this.uid}) : super(key: key);
  @override
  ProfileTabState createState() => new ProfileTabState(uid: uid);
}

class ProfileTabState extends State<ProfileTab>
{
  String imageurl;
  String name;
  String email;
  final String uid;

  ProfileTabState({Key key, @required this.uid});

  Future<void> read() async{
      final DocumentSnapshot documentSnapshot = await Firestore.instance.collection("users").document(uid).get();
      if(documentSnapshot!=null){
        setState(() {
          imageurl = documentSnapshot['photourl'];
          name = documentSnapshot['name'];
          email = documentSnapshot['email'];
        });
      }
  }

  @override
  void initState(){
    super.initState();
    read();
  }

  AuthStore _authStore = new AuthStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(name, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25.0, color: Colors.black)),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
              accountName: new Text(name),
              accountEmail: new Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(imageurl),
              ),
            ),

            new ListTile(
              leading: Icon(Icons.settings, color: Colors.black54),
              title: Text('Settings', style: TextStyle(color: Colors.black54)),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              },
            ),

            new ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black54),
              title: Text('Log Out', style: TextStyle(color: Colors.black54)),
                onTap: (){
                _authStore.getFacebookLogin().logOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),

      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
            clipper: getClipper(),
          ),
          
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 6.4,
            child: Column(
              children: <Widget>[
                Container(
                  width: 130.0,
                  height: 130.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageurl),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(65.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black, spreadRadius: 2.0)
                    ]
                  )
                ),

                SizedBox(height: 25.0),

                Text(name, style: TextStyle(fontSize: 25.0)),

                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Posts', style: TextStyle(fontSize: 15.0, shadows: [
                          Shadow(blurRadius: 1.5, color: Colors.black54)
                        ])),
                        SizedBox(height: 5.0),
                        Text('2', style: TextStyle(fontSize: 18.0),)
                      ],
                    ),
                    SizedBox(width: 25.0),
                    Column(
                      children: <Widget>[
                        Text('Friends', style: TextStyle(fontSize: 15.0, shadows: [
                          Shadow(blurRadius: 1.5, color: Colors.black54)
                        ])),
                        SizedBox(height: 5.0),
                        Text('15', style: TextStyle(fontSize: 18.0),)
                      ],
                    )
                  ],
                ),

                SizedBox(height: 20.0),

                RawMaterialButton(
                  shape: StadiumBorder(),
                  fillColor: Colors.orangeAccent,
                  splashColor: Colors.deepOrangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  elevation: 5.0,
                  child: Text('View Uploads',style: TextStyle(fontSize: 15.0)),
                  onPressed: (){

                  },
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height/2.5);
    path.lineTo(size.width+400, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}