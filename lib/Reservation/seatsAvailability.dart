import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/customWidgets/BusSeatingLayout/basicLayout.dart';
import 'package:flutter/material.dart';

class SeatsAvailability extends StatefulWidget {
  final DocumentSnapshot bus;

  SeatsAvailability(this.bus);

  @override
  State<StatefulWidget> createState() {
    return SeatsAvailabilityState();
  }
}

class SeatsAvailabilityState extends State<SeatsAvailability> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    //StripePayment.setSettings(StripeSettings(publishableKey: "pk_test_NwDyNtEZ6cABXYM8OM9eqvsr006ZlfJIbY"));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Your Seat',
            style: TextStyle(fontFamily: 'Ubuntu'),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  buttonColor: Colors.deepPurple,
                  child: RaisedButton(
                    onPressed: () {
                      // StripePayment.addSource().then((token){

                      // });
                    },
                    child: Text("Proceed"),
                  ),
                ),
              ]),
          color: Colors.blue,
        ),
        body: Column(
          children: <Widget>[
            getRows(),
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
              buttonColor: isPressed ? Colors.green : Colors.grey,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    isPressed = !isPressed;
                  });
                },
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
