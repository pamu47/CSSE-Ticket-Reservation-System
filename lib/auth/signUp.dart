import 'package:csse_booking_system/Homepage/home.dart';
import 'package:csse_booking_system/auth/signIn.dart';
import 'package:csse_booking_system/customWidgets/stacked_icons.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  BaseAuthentication auth = Authentication();
  var _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              StakedIcons(),
              SizedBox(
                height: 15,
              ),
              Text(
                "Smart Partner",
                style: TextStyle(
                    fontFamily: 'Capriola',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("___Lets get you set up___ ",
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0)),
              SizedBox(
                height: 10,
              ),
              Text("Signup to reserve bus tickets and enjoy our services",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                  )),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: new TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter Name';
                    }
                  },
                  decoration: new InputDecoration(
                      labelText: 'Full Name', hintText: 'john Doe'),
                  controller: nameController,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: new TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter Email';
                    }
                  },
                  decoration: new InputDecoration(
                      labelText: 'Email', hintText: 'johnDoe@gmail.com'),
                  controller: emailController,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: new TextFormField(
                  obscureText: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    }
                  },
                  decoration: new InputDecoration(labelText: 'Password'),
                  controller: passwordController,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                minWidth: 250,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.black,
                  child: Text("SignUp"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Future<String> user = auth
                          .signUp(emailController.text, passwordController.text,
                              nameController.text);
                      
                      
                      if (user != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      } else {
                        // Have to change
                        //Navigator.pushNamed(context, '/home');
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Divider(
                        color: Colors.black,
                        indent: 12.0,
                      )),
                  Expanded(
                      child: Center(
                          child: Text('or',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)))),
                  Expanded(
                      flex: 1,
                      child: Divider(
                        color: Colors.black,
                        endIndent: 12.0,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ButtonTheme(
                minWidth: 250,
                child: RaisedButton(
                  color: Color(0xfff4c83f),
                  textColor: Colors.black,
                  child: Text("Sign In"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 250,
                child: FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(FontAwesomeIcons.google), //`Icon` to display
                  label: Text('Continue with Google'), //`Text` to display
                  onPressed: () {},
                ),
              ),
              ButtonTheme(
                minWidth: 250,
                child: FlatButton.icon(
                  color: Color(0xff3399fe),
                  icon: Icon(FontAwesomeIcons.facebook), //`Icon` to display
                  label: Text('Continue with Facebook'), //`Text` to display
                  onPressed: () {
                    //Code to execute when Floating Action Button is clicked
                    //...
                  },
                ),
              ),
            ],
          )),
    ]));
  }
}
