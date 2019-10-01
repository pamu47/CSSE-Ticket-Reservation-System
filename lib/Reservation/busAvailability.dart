import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/Reservation/seatsAvailability.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../customWidgets/customListTile.dart';

class BusAvailability extends StatefulWidget {
  final String source, destination;

  BusAvailability(this.source, this.destination);

  @override
  State<StatefulWidget> createState() {
    return BusAvailabilityState(source, destination);
  }
}

class BusAvailabilityState extends State<BusAvailability> {
  final String from, to;
  TextEditingController source = TextEditingController();
  TextEditingController destination = TextEditingController();
  BusAvailabilityState(this.from, this.to);

  @override
  void initState() {
    super.initState();
    source.text = from;
    destination.text = to;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(35, 37, 40, 1),
          title: Text(
            'BOOK YOUR BUS',
            style: TextStyle(
              fontFamily: 'Ubuntu',
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              color: Color.fromRGBO(35, 37, 40, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        height: 35.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.white),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Ubuntu'),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: source,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Icon(
                      FontAwesomeIcons.carSide,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        height: 35.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.white),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Ubuntu'),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: destination,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Expanded(
                //top: 100.0,

                child: Container(
              child: FutureBuilder(
                future: getBusData(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        var busTurn = snapshot.data[index].data["$from-$to"];
                        
                        return Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeatsAvailability(snapshot.data[index])));
                            },
                            child: CustomListItemTwo(
                              thumbnail: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.pink),
                              ),
                              title: '${snapshot.data[index].data["company"]}',
                              subtitle: '$from : ${busTurn['departure']} \n'
                                  '$to : ${busTurn['arrival']} \n'
                                  '${snapshot.data[index].data["options"]}',
                              author:
                                  '${busTurn['availableSeats']} Seats Available',
                              publishDate: 'type',
                              readDuration:
                                  'Rs. ${snapshot.data[index].data["price"]} per person',
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )),
            RaisedButton(
              child: Text('Test'),
              onPressed: () {
                var products;
                getBusData().then((data) {
                  for (int i = 0; i < data.length; i++) {
                    //print('______________ ${data[i]['company']}');
                    products = data[i];
                    //print('______________ ${data[i]['company']} , ');
                    if (products != null) {
                      products.forEach((product) {
                        //print('Data ::::: ${product.data.values}');
                      });
                    }
                  }
                });
              },
            )
          ],
        ));
  }

  Future getBuses() async {
    var firestore = Firestore.instance;
    QuerySnapshot qs =
        await firestore.collection("routes/colombo-kandy/bus").getDocuments();
    return qs.documents;
  }

  Future<List<DocumentSnapshot>> getBusData() async {
    //print('Called>>>>>>>>>>>>>>');
    var data = await Firestore.instance
        .collection('routes')
        .document('colombo-kandy')
        .collection('bus')
        .orderBy("$from-$to", descending: false)
        .getDocuments();
    var busData = data.documents;
    //print('Called>>>>>>>>>>>>>>${busData[0]['company']}');
    return busData;
  }
}
