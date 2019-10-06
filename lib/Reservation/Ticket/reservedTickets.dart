import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/Reservation/Ticket/ticket.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservedTickets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReservedTicketsState();
  }
}

class ReservedTicketsState extends State<ReservedTickets> {
  BaseAuthentication auth = Authentication();
  static String currentUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FutureBuilder futureBuilder;

  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((userID) {
      currentUser = userID.toString();
    });
    _saveToken();
  }

  _saveToken() async {
    String uid = currentUser;
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
    getCompletedList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.panorama_horizontal),
                  text: "View Tickets",
                ),
                Tab(
                  icon: Icon(Icons.train),
                  text: "Ongoing Trips",
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: "Purchase History",
                ),
              ],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.white, width: 4),
                insets: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            title: Text('Tickets'),
          ),
          body: TabBarView(
            children: <Widget>[
              Hero(
                tag: 'ticket',
                child: FutureBuilder(
                  future: getReservations(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          var trip =
                              snapshot.data[index].data['from-to'].toString();
                          var cost =
                              snapshot.data[index].data['cost'].toString();
                          var numberOfTickets = snapshot
                              .data[index].data['numberOfTickets']
                              .toString();
                          var docId = snapshot.data[index].documentID;
                          return InkWell(
                            child: customListItem(trip, cost, numberOfTickets),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Ticket(currentUser,
                                          docId, trip, cost, numberOfTickets)));
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              //Second Tab
              FutureBuilder(
                future: getOngoingTickets(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return Center(
                      child: Text('Error'),
                    );
                  } else {
                    print('Data::: ${asyncSnapshot.data.toString()}');
                    return ListView.builder(
                      itemCount: asyncSnapshot.data.length,
                      itemBuilder: (_, index) {
                        var trip = asyncSnapshot.data[index].data['from-to']
                            .toString();
                        var cost =
                            asyncSnapshot.data[index].data['cost'].toString();
                        var numberOfTickets = asyncSnapshot
                            .data[index].data['numberOfTickets']
                            .toString();
                        var docId = asyncSnapshot.data[index].documentID;
                        return InkWell(
                          child: customListItem(trip, cost, numberOfTickets),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ticket(currentUser,
                                        docId, trip, cost, numberOfTickets)));
                          },
                        );
                      },
                    );
                  }
                },
              ),
              //Third Tab
              FutureBuilder(
                future: getCompletedTickets(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return Center(
                      child: Text('Error'),
                    );
                  } else {
                    print('Data::: ${asyncSnapshot.data.toString()}');
                    return ListView.builder(
                      itemCount: asyncSnapshot.data.length,
                      itemBuilder: (_, index) {
                        var trip = asyncSnapshot.data[index].data['from-to']
                            .toString();
                        var cost =
                            asyncSnapshot.data[index].data['cost'].toString();
                        var numberOfTickets = asyncSnapshot
                            .data[index].data['numberOfTickets']
                            .toString();
                        var docId = asyncSnapshot.data[index].documentID;
                        return InkWell(
                          child: customListItem(trip, cost, numberOfTickets),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ticket(currentUser,
                                        docId, trip, cost, numberOfTickets)));
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget getCompletedList() {
    return StreamBuilder();
  }

  Future<List<DocumentSnapshot>> getReservations() async {
    var data = await Firestore.instance
        .collection('reservations')
        .document('$currentUser')
        .collection('records')
        .where('tripStatus', isEqualTo: 'pending')
        .getDocuments();
    var reservationData = data.documents;
    return reservationData;
  }

  Future<List<DocumentSnapshot>> getOngoingTickets(
      {int offset, int limit}) async {
    var data = await Firestore.instance
        .collection('reservations')
        .document('$currentUser')
        .collection('records')
        .where('tripStatus', isEqualTo: 'ongoing')
        .getDocuments();
    var reservationData = data.documents;
    return reservationData;
  }

  Future<List<DocumentSnapshot>> getCompletedTickets(
      {int offset, int limit}) async {
    var data = await Firestore.instance
        .collection('reservations')
        .document('$currentUser')
        .collection('records')
        .where('tripStatus', isEqualTo: 'finished')
        .getDocuments();
    var reservationData = data.documents;
    return reservationData;
  }

  Stream<QuerySnapshot> getTicketData({int offset, int limit}) {
    Stream<QuerySnapshot> snapshot = Firestore.instance
        .collection('reservations')
        .document('$currentUser')
        .collection('records')
        .snapshots();
    if (offset != null) {
      snapshot = snapshot.skip(offset);
    }
    if (limit != null) {
      snapshot = snapshot.take(limit);
    }
    return snapshot;
  }

  Widget customListItem(trip, cost, numberOfTickets) {
    return Card(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    '${trip.toString()}',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Rs.${cost.toString()}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text('${numberOfTickets.toString()} Ticket(s)',
                            style: TextStyle(color: Colors.green)),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(right: 30.0),
              alignment: Alignment.centerRight,
              child: QrImage(
                data: "123456",
                version: QrVersions.auto,
                size: 75.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
