import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Home.dart';

class MobileLogin extends StatefulWidget
{
  @override
  MobileLoginState createState() => new MobileLoginState();
}

class MobileLoginState extends State<MobileLogin>
{

  String phoneNo;
  String smsCode;
  String verificationID;

  Future<void> verifyPhone() async{
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID){
        this.verificationID = verID;
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]){
      this.verificationID = verID;
      smsCodeDialog(context).then((value){
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verificationSuccess = (FirebaseUser user){
      print('verified');
    };

    final PhoneVerificationFailed verificationFailed = (AuthException exception){
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed
    );
  }


  Future<bool> smsCodeDialog(BuildContext context)
  {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext){
        return new AlertDialog(
          title: Text('Enter OTP'),
          contentPadding: EdgeInsets.all(10.0),
          content: TextField(
            onChanged: (value){
              this.smsCode = value;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text('Done'),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  if(user!=null){
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  else{
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
              },
            )
          ],
        );
      }
    );
  }

  signIn(){
    FirebaseAuth.instance.signInWithPhoneNumber(
        verificationId: verificationID,
        smsCode: smsCode,).then((user){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e){
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
          child: ListView(
            shrinkWrap: true,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 35.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(icon: Icon(Icons.arrow_back, color: Colors.redAccent, ), iconSize: 30.0, onPressed: null),
                  ],
                ),

                new SizedBox(height: 15.0),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                    new  Text('Enter phone number',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0
                      ),
                    ),
                  ],
                ),

                new SizedBox(height: 35.0),

                new Form(
                  child: new Theme(
                      data: new ThemeData(
                          brightness: Brightness.light,
                          primarySwatch: Colors.lightBlue,
                          inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                              color: Colors.black, fontSize: 25.0,
                            ),
                          )
                      ),
                      child: new Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new TextField(
                              decoration: new InputDecoration(
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 20.0)
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                this.phoneNo = value;
                              },
                              style: TextStyle(fontSize: 20.0, color: Colors.black),
                            ),

                            new SizedBox(height: 25.0),

                            new Text("lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem vvipsum lorem ipsum lorem ", style: TextStyle(fontSize: 13.0),),

                            new SizedBox(height: 15.0),

                            new RawMaterialButton(
                              shape: StadiumBorder(),
                              elevation: 7.0,
                              splashColor: Colors.red,
                              fillColor: Colors.redAccent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 25.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Text('CONTINUE', style: TextStyle(color: Colors.white, fontSize: 20.0),)
                                  ],
                                ),
                              ),
                              onPressed: verifyPhone
                            )
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        );
  }
}