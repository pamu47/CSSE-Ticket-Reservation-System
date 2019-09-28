import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class TimePicker extends StatefulWidget {
  final String labelText;
  final TextEditingController time;
  TimePicker(this.labelText,this.time);
  @override
  State<StatefulWidget> createState() {
    return TimeState(labelText,time);
  }
}

class TimeState extends State<TimePicker> {
  String labelText;
  var dateController = TextEditingController();
  
  TimeState(this.labelText,this.dateController);

  TimeOfDay _time = new TimeOfDay.now();



  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        dateController.text = _time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 12.0, right: 8.0, left: 30.0),
            child: Material(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 5.0,
              child: TextField(
                  enabled: false,
                  controller: dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: labelText,
                  ),
                  style: new TextStyle(
                      fontSize: 20.0, height: 0.6, color: Colors.black)),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
          child: Container(
            child: Material(
              elevation: 5.0,
              color: Colors.grey[300],
              child: FlatButton(
                padding: EdgeInsets.only(right: 1.0),
                child: Icon(FontAwesomeIcons.clock),
                onPressed: () {
                  _selectTime(context);
                },
              ),
            ),
          ),
        ))
      ],
    );
  }
}
