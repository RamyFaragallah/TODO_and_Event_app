import 'package:flutter/material.dart';

class CustomDateTimePicker extends StatelessWidget {
  final VoidCallback onDatepressed,onTimepressed;
  final String pickedDate,pickedTime;

  CustomDateTimePicker(this.onDatepressed,this.pickedDate,this.onTimepressed,this.pickedTime);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: onDatepressed,
                  icon: Icon(Icons.date_range,color: Theme.of(context).accentColor,),
                  label: Text("$pickedDate")), FlatButton.icon(
                  onPressed: onTimepressed,
                  icon: Icon(Icons.access_time,color: Theme.of(context).accentColor,),
                  label: Text("$pickedTime")),
            ],
          ),
        ),
      ],
    );
  }
}
