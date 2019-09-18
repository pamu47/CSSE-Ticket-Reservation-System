import 'package:csse_booking_system/customWidgets/appDrawer.dart';
import 'package:flutter/material.dart';
 
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget{
  final FirebaseUser currentUser;

  Home(this.currentUser);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}

class HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: AppDrawer(),
      body: Text('Welcome ${widget.currentUser.uid}'),
    );
  }

}