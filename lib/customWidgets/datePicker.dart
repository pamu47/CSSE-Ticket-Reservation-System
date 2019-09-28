import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class DateTimePicker extends StatefulWidget {
  final String labelText;
  DateTimePicker(this.labelText);
  @override
  State<StatefulWidget> createState() {
    return DateTimeState(labelText);
  }
}

class DateTimeState extends State<DateTimePicker> {
  String labelText;
  DateTimeState(this.labelText);
  DateTime _date = DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  var dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        dateController.text = _date.year.toString() +
            ' - ' +
            _date.month.toString() +
            ' - ' +
            _date.day.toString();
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
          padding: const EdgeInsets.only(right: 20.0, bottom: 8.0),
          child: Container(
            child: Material(
              elevation: 5.0,
              color: Colors.grey[300],
              child: FlatButton(
                padding: EdgeInsets.only(right: 1.0),
                child: Icon(FontAwesomeIcons.calendarAlt),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            ),
          ),
        ))
      ],
    );
  }
}
