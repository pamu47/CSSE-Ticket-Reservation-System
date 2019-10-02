import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/Reservation/qrGeneration.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:flutter/material.dart';

class SeatsAvailability extends StatefulWidget {
  final DocumentSnapshot bus;
  final String from, to;

  SeatsAvailability(this.bus, this.from, this.to);

  @override
  State<StatefulWidget> createState() {
    return SeatsAvailabilityState();
  }
}

class SeatsAvailabilityState extends State<SeatsAvailability> {
  BaseAuthentication auth = Authentication();
  Future<DocumentSnapshot> user;
  DocumentSnapshot userData;
  bool isPressed = false;
  bool hasCredit = true;
  int ticketCount = 0;
  double cost = 0;
  TextEditingController tickets = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((currentuser) {
      print('Home:::: $currentuser');
      user = Firestore.instance
          .collection('users')
          .document(currentuser)
          .get()
          .then((value) {
        userData = value;
      });
    });
    //StripePayment.setSettings(StripeSettings(publishableKey: "pk_test_NwDyNtEZ6cABXYM8OM9eqvsr006ZlfJIbY"));
    setState(() {
      tickets.text = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Route Data:::::${widget.bus.data['colombo-kandy']['availableSeats'].toString()}');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Your Seat',
            style: TextStyle(fontFamily: 'Ubuntu'),
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            RaisedButton(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  initState();
                });
              },
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            ButtonTheme(
              minWidth: 200,
              buttonColor: Colors.black,
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            title: Text(
                              "Number of Tickets",
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Container(
                              height: 320,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text('Ticket Price',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                              )),
                                          flex: 3,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Rs.' +
                                                widget.bus.data['price']
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text('Your Credits',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                              )),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              'Rs.' +
                                                  userData.data['credits']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: RaisedButton(
                                            padding:
                                                EdgeInsets.only(right: 2.0),
                                            child: Icon(
                                              Icons.remove_circle_outline,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              if (int.parse(tickets.text) !=
                                                  0) {
                                                ticketCount--;
                                              }
                                              cost = ticketCount *
                                                  double.parse(widget
                                                      .bus.data['price']
                                                      .toString());
                                              if (cost <
                                                  double.parse(userData
                                                      .data['credits']
                                                      .toString())) {
                                                setState(() {
                                                  hasCredit = true;
                                                });
                                              }
                                              setState(() {
                                                tickets.text =
                                                    ticketCount.toString();
                                                costController.text =
                                                    'Rs.' + cost.toString();
                                              });
                                            },
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0, left: 20.0),
                                          child: Container(
                                            height: 50.0,
                                            child: TextField(
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              controller: tickets,
                                              decoration: new InputDecoration(
                                                  labelText: 'Tickets',
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: RaisedButton(
                                            padding: EdgeInsets.only(left: 2.0),
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              var count = (int.parse(userData
                                                          .data['credits']
                                                          .toString()) /
                                                      int.parse(widget
                                                          .bus.data['price']
                                                          .toString()))
                                                  .toInt()
                                                  .floor();
                                              // var count = userData
                                              //             .data['credits'] / widget
                                              //             .bus.data['price'];

                                              if (count >
                                                  int.parse(tickets.text)) {
                                                ticketCount++;
                                                cost = ticketCount *
                                                    double.parse(widget
                                                        .bus.data['price']
                                                        .toString());
                                              }
                                              setState(() {
                                                tickets.text =
                                                    ticketCount.toString();
                                                costController.text =
                                                    'Rs.' + cost.toString();
                                              });
                                            },
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 50.0,
                                            child: TextField(
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              controller: costController,
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 30.0),
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: new InputDecoration(
                                                  border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ButtonTheme(
                                    minWidth: 200.0,
                                    child: RaisedButton(
                                      color: Colors.purple[600],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.forward,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Proceed',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QrGeneration(
                                                        widget.bus,
                                                        userData,
                                                        widget.from,
                                                        widget.to,
                                                        tickets.text)));
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: 200.0,
                                    child: RaisedButton(
                                      color: Colors.purple[600],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.credit_card,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Credit Your Account',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                Navigator.defaultRouteName));
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                },
                child: Text(
                  "Proceed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
          color: Colors.white,
        ),
        body: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              //padding: const EdgeInsets.only(left:10.0),
              child: Text('${widget.bus.data['company'].toString()}',
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 30.0)),
            ),
            Divider(
              color: Colors.purple[600],
              endIndent: 20,
              indent: 20,
            ),
            getRows(),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Container(
                height: 50.0,
                child: TextField(
                  decoration: new InputDecoration(
                      labelText: 'Number of Seats',
                      border: OutlineInputBorder()),
                ),
              ),
            )
          ],
        ));
  }

  Widget getRows() {
    List<Row> list = new List<Row>();
    for (var i = 0; i < 8; i++) {
      list.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4.0),
            child: ButtonTheme(
              minWidth: 30,
              buttonColor: Colors.purple[600],
              child: RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.event_seat,
                  size: 15.0,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            child: ButtonTheme(
              minWidth: 30.0,
              buttonColor: Colors.purple[600],
              child: RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.event_seat,
                  size: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            child: ButtonTheme(
              minWidth: 30.0,
              buttonColor: Colors.purple[600],
              child: RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.event_seat,
                  size: 15.0,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            child: ButtonTheme(
              minWidth: 30.0,
              buttonColor: Colors.purple[600],
              child: RaisedButton(
                onPressed: () {},
                child: Icon(
                  Icons.event_seat,
                  size: 15.0,
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return new Column(children: list);
  }
}
