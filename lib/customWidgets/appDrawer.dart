import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AppDrawer extends StatelessWidget {
  //static BaseAuthentication auth = Authentication();
  
  static FirebaseAuth auth = FirebaseAuth.instance;
  static String userId;

void getUser()async{
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
  }
  AppDrawer();
    

  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: InkWell(
              child: Icon(
                Icons.account_circle,
                size: 75.0,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));
              },
            ),
            accountEmail: Text("pamuditha@gmail.com"),
            accountName: Text('abcd::::'),
            decoration: BoxDecoration(
              color: Color.fromRGBO(18, 69, 89, 1),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.hospital),
              title: Text('Departments'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.userNurse),
              title: Text('Staff'),
              onTap: () {
                Navigator.pop(context);
                //             Navigator.push(context,
                // MaterialPageRoute(builder: (context) => ));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.procedures),
              title: Text('Patients'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));
                //Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
              onTap: () {
                Navigator.pop(context);
                //             Navigator.push(context,
                // MaterialPageRoute(builder: (context) => ));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Noticeboard'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));
                auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}
