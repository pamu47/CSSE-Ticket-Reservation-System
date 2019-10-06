import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneration extends StatefulWidget {
  final DocumentSnapshot userData;
  final DocumentSnapshot bus;
  final String from, to, numberOfTickets;

  QrGeneration(
      this.bus, this.userData, this.from, this.to, this.numberOfTickets);

  @override
  State<StatefulWidget> createState() {
    return QrGenerationState();
  }
}

class QrGenerationState extends State<QrGeneration> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String getArrival() {
    String arrival =
        widget.bus.data['${widget.from}-${widget.to}']['arrival'].toString();
    return arrival;
  }

  String getDeparture() {
    String departure =
        widget.bus.data['${widget.from}-${widget.to}']['departure'].toString();
    return departure;
  }

  int reserveSeat() {
    int seatCount = int.parse(widget
            .bus.data['${widget.from}-${widget.to}']['availableSeats']
            .toString()) -
        int.parse(widget.numberOfTickets.toString());
    return seatCount;
  }

  String calcCost() {
    int cost = int.parse(widget.bus.data['price'].toString()) *
        int.parse(widget.numberOfTickets.toString());
    return cost.toString();
  }

  int calcbalance() {
    int balance = int.parse(widget.userData.data['credits'].toString()) -
        int.parse(calcCost().toString());
    return balance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Get Your Ticket',
          style: TextStyle(fontFamily: 'Ubuntu'),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 75.0,
              child: Card(
                elevation: 5.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Center(
                          child: Text(
                        '${widget.from}',
                        style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20.0),
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                          child: Text('${widget.to}',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu', fontSize: 20.0))),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                  elevation: 5.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Ticket Price',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu', fontSize: 15.0),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                'Rs.${widget.bus.data['price']}',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu', fontSize: 15.0),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Number of Tickets',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu', fontSize: 15.0),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                '${widget.numberOfTickets}',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu', fontSize: 15.0),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Total Price',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu', fontSize: 15.0),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                'Rs.${calcCost().toString()}',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15.0,
                                    color: Colors.red),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Account Balance',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu', fontSize: 15.0),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                'Rs.${widget.userData.data['credits']}',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15.0,
                                    color: Colors.green),
                              )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Balance After Reservation',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu', fontSize: 15.0),
                                  )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                'Rs.${calcbalance().toString()}',
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 15.0,
                                ),
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              height: 200.0,
              width: 200.0,
              child: Card(
                elevation: 5.0,
                child: QrImage(
                  data:
                      "${widget.userData.documentID} :::: ${widget.bus.documentID} :::: ${widget.from}-${widget.to} ::::: ${calcCost()}::::: ${widget.numberOfTickets}",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: ButtonTheme(
                minWidth: 200.0,
                child: RaisedButton(
                  color: Colors.purple[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        Text(
                          'Confirm and Save Ticket',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              title: Text(
                                "Warning!",
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Container(
                                height: 150,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                        'Please re-check all the details brfore you proceed.'),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: ButtonTheme(
                                              minWidth: 75.0,
                                              child: RaisedButton(
                                                color: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(Icons.cancel),
                                                      Text('Back')
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             ));
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ButtonTheme(
                                              minWidth: 75.0,
                                              child: RaisedButton(
                                                color: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(Icons.done),
                                                      Text('Proceed')
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  String msg =
                                                      'Your reservation is successfull\nFrom : ${widget.from} To:${widget.to}\n Time : ${getDeparture()} - ${getArrival()}\nCost : ${calcCost()}\n -Thanks for using Smart Partner-';
                                                  sendConfirmation(msg)
                                                      .then((data) {
                                                    print(
                                                        'Confirmation message :: ${data.toString()}');
                                                  });
                                                  updateSeatCount();
                                                  updateCreditLevel();
                                                  createReservation();
                                                  Navigator.pop(context);
                                                  showSnackBar();
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSnackBar() {
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      elevation: 3.0,
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0)),
      content: new Text(
        'Reservation Successfull',
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'Done',
        onPressed: () {},
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  updateSeatCount() async {
    await Firestore.instance
        .collection('routes')
        .document('${widget.from}-${widget.to}')
        .collection('bus')
        .document(widget.bus.documentID)
        .updateData({
      '${widget.from}-${widget.to}': {
        'arrival': getArrival(),
        'departure': getDeparture(),
        'availableSeats': reserveSeat()
      }
    });
  }

  updateCreditLevel() async {
    await Firestore.instance
        .collection('users')
        .document(widget.userData.documentID)
        .updateData({'credits': calcbalance()});
  }

  createReservation() async {
    await Firestore.instance
        .collection('reservations')
        .document(widget.userData.documentID)
        .collection('records')
        .add({
      'from-to': '${widget.from}-${widget.to}',
      'numberOfTickets': '${widget.numberOfTickets}',
      'uid': '${widget.userData.documentID}',
      'tripStatus': 'pending',
      'cost': '${calcCost()}'
    });
  }

  Future<String> sendConfirmation(String msg) async {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'bookingConfirmationMsg');
    Map<String, dynamic> data = new Map();
    data['message'] = msg;
    HttpsCallableResult result = await callable.call(data);
    return result.data.toString();
  }
}

//reserveSeat()
//${widget.from}-${widget.to}']['availableSeats']

//widget.bus.data['${widget.from}-${widget.to}']['availableSeats']
