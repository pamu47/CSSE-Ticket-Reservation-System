import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Ticket extends StatefulWidget {
  String currentUser, docId, trip, cost, numberOfTickets;

  Ticket(
      this.currentUser, this.docId, this.trip, this.cost, this.numberOfTickets);

  @override
  State<StatefulWidget> createState() {
    return TicketState();
  }
}

class TicketState extends State<Ticket> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String getQRdata() {
    String data =
        '${widget.currentUser}\n${widget.docId}\n${widget.trip}\n${widget.cost}\n${widget.numberOfTickets}';
    return data;
  }

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print('inside ticket cloud msg');
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () {},
        //   ),
        // );
        // Scaffold.of(context).showSnackBar(snackbar);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: ListTile(
                    leading: getAssetImage(),
                    title: Text(message['notification']['title'],style: TextStyle(fontFamily: 'Ubuntu',fontSize: 18.0,fontWeight: FontWeight.bold),),
                    subtitle: Text(message['notification']['body'],style: TextStyle(fontFamily: 'Ubuntu'),)
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }
    Widget getAssetImage() {
    AssetImage assetImage = AssetImage('images/place.png');
    Image image = Image(
      image: assetImage,
      width: 75.0,
      height: 75.0,
    );
    return Container(child: image);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: 'ticket',
            child: QrImage(
              data: getQRdata(),
              version: QrVersions.auto,
              size: 175.0,
            ),
          ),
        ),
      ),
    );
  }
}
