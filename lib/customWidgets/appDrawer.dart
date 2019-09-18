import 'package:csse_booking_system/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: InkWell(
              child: Icon(Icons.account_circle, size: 75.0,color: Colors.white,),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));
              },
            ),
            accountEmail: Text("pamuditha@gmail.com"),
            accountName: Text("Pamuditha"),
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
              leading: Icon(FontAwesomeIcons.fileInvoiceDollar),
              title: Text('logout'),
              onTap: () async {
                Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ));

                try {
                        FirebaseUser result =
                            await Provider.of<AuthService>(context).logout();
                        print(result);
                      } on AuthException catch (error) {
                        return _buildErrorDialog(context, error.message);
                      } on Exception catch (error) {
                        return _buildErrorDialog(context, error.toString());
                      }
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