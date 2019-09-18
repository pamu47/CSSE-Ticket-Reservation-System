import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_booking_system/Homepage/home.dart';
import 'package:csse_booking_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context,name) {
    Firestore.instance.collection('/users').add({
      'name' : name,
      'email' : user.email,
      'uid' : user.uid
    }).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }).catchError((e) {
      print(e);
    });
  }
}
