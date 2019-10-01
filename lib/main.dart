import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/auth/signIn.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:flutter/material.dart';
import 'Homepage/home.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  BaseAuthentication _auth = Authentication();
  DocumentSnapshot user;

  @override
  void initState() {
    super.initState();
    print('Inside init');
    _auth.getCurrentUser().then((currentUser) {
      if (currentUser == null) {
        print('No current user;;;');
        Timer(Duration(seconds: 5), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        });
      } else {
        print('Current User :::::  $currentUser');
        Timer(Duration(seconds: 5), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      getAssetImage(),
                      Text(
                        "Smart Partner",
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    //Text("CodeWarriors")
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getAssetImage() {
    AssetImage assetImage = AssetImage('images/transport.png');
    Image image = Image(
      image: assetImage,
      width: 200.0,
      height: 200.0,
    );
    return Container(child: image);
  }
    Future<DocumentSnapshot> getUserData(currentUser) async {
    //print('Called>>>>>>>>>>>>>>');
    var data = await Firestore.instance
              .collection('users')
              .document(currentUser)
              .get();
    var userData = data;
    //print('Called>>>>>>>>>>>>>>${busData[0]['company']}');
    return userData;
  }
}
