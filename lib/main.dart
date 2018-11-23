import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:near_way/AuthStore.dart';
import 'package:near_way/Login.dart';
import 'package:near_way/home/Home.dart';

var myKey = 'AIzaSyCZvqa0dfN6w2BPvZiQVUD3-30DTLsNpEY';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "NearWay", home: StartupActivity());
  }
}

class StartupActivity extends StatelessWidget {
  static final _authStore = new AuthStore();

  _redirect(context) async {
    final FacebookAccessToken accessToken =
        await _authStore.getFacebookLogin().currentAccessToken;
    if (accessToken != null)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    else
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _redirect(context);
    return Scaffold();
  }
}
