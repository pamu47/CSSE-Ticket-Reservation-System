import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/services/searchService.dart';
import 'package:flutter/material.dart';

class NewReservation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewReservationState();
  }
}

class NewReservationState extends State<NewReservation> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedVal = value.substring(0,1).toUpperCase() + value.substring(1);
    if(queryResultSet.length == 0 && value.length == 1){
      SearchService().searchByName(value).then((QuerySnapshot docs){
        for(int i = 0; i < docs.documents.length;i++){
          queryResultSet.add(docs.documents[i].data);
        }
      });
    }else{
      tempSearchStore = [];
      queryResultSet.forEach((element){
        if(element['name'].startsWith(capitalizedVal)){
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: new TextField(
              decoration: new InputDecoration(
                  labelText: 'Email',
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
              onChanged: (value) {
                initiateSearch(value);
              },
            ),
          ),
          SizedBox(height: 20.0,),
          ListView(
            padding: EdgeInsets.only(left: 10,right: 10),
            primary: false,
            shrinkWrap: true,
            children: 
              tempSearchStore.map((element){
                return buildResultCard(element);
              }).toList()
            ,
          ),
          Text('Hello')
        ],
      ),
    );
  }
}

Widget buildResultCard(data){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: Center(
        child: Text(data['name']),
        
      ),
    ),
  );
}