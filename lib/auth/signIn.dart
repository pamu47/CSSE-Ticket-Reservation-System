import 'package:csse_booking_system/customWidgets/customLoginTextField.dart';
import 'package:csse_booking_system/customWidgets/stacked_icons.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: new IconThemeData(color: Color(0xFF18D191))),
        body: ListView(children: <Widget>[
          Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  StakedIcons(),
                  SizedBox(height: 60,),
                  CustomLoginTextField(
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      "Email")
                ],
              )),
        ]));
  }
}
