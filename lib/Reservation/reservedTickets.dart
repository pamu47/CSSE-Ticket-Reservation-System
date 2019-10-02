import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
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

  @override
  void initState() {
    super.initState();
    auth.getCurrentUser().then((userID){
      currentUser = userID.toString();
    });
    print('Ticket :::: $currentUser');
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
              Container(
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
                          return InkWell(
                            child: customListItem(snapshot.data[index].data['from-to'].toString()),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Icon(Icons.add_comment)
            ],
          ),
        ));
  }

  Future<List<DocumentSnapshot>> getReservations() async {
    var data = await Firestore.instance
        .collection('reservations')
        .document('$currentUser')
        .collection('records')
        .getDocuments();
    var reservationData = data.documents;
    return reservationData;
  }

  Widget customListItem(trip) {
    return Card(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: <Widget>[Text('data'), Text('${trip.toString()}')],
              ),
            ),
          ),
          Expanded(
            flex: 3,
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
