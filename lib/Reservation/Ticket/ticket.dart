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
                  content: ListTile(
                    title: Text(message['notification']['title']),
                    subtitle: Text(message['notification']['body']),
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
    _saveToken();
  }

  _saveToken() async {
    String uid = widget.currentUser;
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      var tokenRef = Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);
      await tokenRef.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
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
