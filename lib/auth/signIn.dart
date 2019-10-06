import 'package:csse_booking_system/Homepage/home.dart';
import 'package:csse_booking_system/auth/signUp.dart';
import 'package:csse_booking_system/customWidgets/stacked_icons.dart';
import 'package:csse_booking_system/services/usermanagement.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  BaseAuthentication auth = Authentication();
  var _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                height: 20,
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
              Text("___Sign In___ ",
                  style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0)),
              SizedBox(
                height: 10,
              ),
              Text("Signup to reserve bus tickets and enjoy our services",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                  )),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: new TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter Email';
                    }
                  },
                  decoration: new InputDecoration(labelText: 'Email'),
                  controller: emailController,
                ),
              ),
              SizedBox(
                height: 20,
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
                height: 30,
              ),
              ButtonTheme(
                minWidth: 250,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.black,
                  child: Text("Sign In"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _userLogin();
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
                  child: Text("Sign Up"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ),
            ],
          )),
    ]));
  }

  Future _userLogin() async {
    //Firebase remote config

    //If auth is enabled in remote
    // final formState = _formKey.currentState;
    // if (formState.validate()) {
    //   formState.save();

    print(emailController.text);
    print(passwordController.text);
    Future<String> userId =
        auth.signIn(emailController.text, passwordController.text);

    userId.then((user) {
      if (user.length > 0 && user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        print("User id is null");
        _buildErrorDialog(context, 'Please check your credentials');
      }
    }).catchError((error){
      _buildErrorDialog(context, error);
    });
  }
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message.toString()),
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
