import 'package:flutter/material.dart';

class BasicLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BasicLayoutState();
  }
}

class BasicLayoutState extends State<BasicLayout> {

  bool isPressed = false;
  int seatNo = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4.0),
              child: ButtonTheme(
                minWidth: 30,
                buttonColor: isPressed ? Colors.green : Colors.grey,
                child: RaisedButton(
                  key:UniqueKey(),
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
            SizedBox(
              width: 50.0,
            ),
            Container(
              padding: EdgeInsets.all(4.0),
              child: ButtonTheme(
                minWidth: 30.0,
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
                  onPressed: () {
                  },
                  child: Icon(
                    Icons.event_seat,
                    size: 15.0,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  seatList(String seatNo){
    List<String> list = new List();
    setState(() {
      list.add(seatNo);
    });
    return list;
  }
}
