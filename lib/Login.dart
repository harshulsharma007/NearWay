import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:near_way/AuthStore.dart';
import 'package:near_way/home/Home.dart';
import 'LoginWithMobile.dart';

class LoginPage extends StatelessWidget {
  final AuthStore _authStore = new AuthStore();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new Image(
            image: AssetImage("assets/Login_image.jpg"),
            fit: BoxFit.cover,
            color: Colors.white24,
            colorBlendMode: BlendMode.lighten,
          ),
          new Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            margin: EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Image(
                      image: AssetImage("assets/Nearway.png"),
                    ) //Text('Nearway', style: TextStyle(color: Colors.black54, fontSize: 60.0, fontWeight: FontWeight.w300)),
                    ),
                new Padding(padding: EdgeInsets.only(top: 100.0)),
                new RawMaterialButton(
                  elevation: 4.0,
                  fillColor: Colors.blue,
                  splashColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  shape: StadiumBorder(),
                  onPressed: () {
                    _authStore.getFacebookLogin().logInWithReadPermissions(
                        ['email', 'public_profile']).then((result) {
                      switch (result.status) {
                        case FacebookLoginStatus.loggedIn:
                          FirebaseAuth.instance
                              .signInWithFacebook(
                                  accessToken: result.accessToken.token)
                              .then((signedInUser) {
                            print('Signed in as ${signedInUser.displayName}');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (Route<dynamic> route) => false);
                          }).catchError((e) {
                            print(e);
                          });
                          break;
                      }
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text('LOG IN WITH FACEBOOK',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500))
                        ],
                      )),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new RawMaterialButton(
                  elevation: 4.0,
                  fillColor: Colors.white70,
                  splashColor: Colors.black26,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey, width: 1.2)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MobileLogin()));
                  },
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Text('LOG IN WITH MOBILE NUMBER',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500))
                          ])),
                )
              ],
            ),
          ),
        ]));
  }
}
