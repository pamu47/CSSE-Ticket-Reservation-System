import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/customWidgets/datePicker.dart';
import 'package:csse_booking_system/customWidgets/timePicker.dart';
import 'package:csse_booking_system/services/searchService.dart';
import 'package:flutter/material.dart';

class NewReservation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewReservationState();
  }
}

class NewReservationState extends State<NewReservation> {
  TextEditingController time = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  bool from = false;
  bool to = false;
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  initiateSearch(value, loc) {
    if (loc == 'from') {
      setState(() {
        from = true;
        to = false;
      });
    } else if (loc == 'to') {
      setState(() {
        to = true;
        from = false;
      });
    }
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedVal =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedVal)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Bus'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8.0),
            height: 400,
            child: Card(
              elevation: 5.0,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 10.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(5.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                            labelText: 'From', border: OutlineInputBorder()),
                        onChanged: (value) {
                          initiateSearch(value, 'from');
                        },
                        controller: sourceController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  from
                      ? ListView(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildSourceResultCard(element);
                          }).toList(),
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(5.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'To',
                        ),
                        onChanged: (value) {
                          initiateSearch(value, 'to');
                        },
                        controller: destinationController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  to
                      ? ListView(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildDestinationResultCard(element);
                          }).toList(),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  DateTimePicker('Select Date'),
                  SizedBox(
                    height: 20.0,
                  ),
                  TimePicker('Select Time', time),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSourceResultCard(data) {
    return InkWell(
      onTap: () {
        setState(() {
          sourceController.text = data['name'];
          tempSearchStore = [];
        });
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(data['name']),
          ),
        ),
      ),
    );
  }

  Widget buildDestinationResultCard(data) {
    return InkWell(
      onTap: () {
        setState(() {
          destinationController.text = data['name'];
          tempSearchStore = [];
        });
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(data['name']),
          ),
        ),
      ),
    );
  }
}
