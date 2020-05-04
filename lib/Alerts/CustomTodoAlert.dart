import 'package:flutter/material.dart';
import 'package:flutter_app/CustomWidgets/CustomButton.dart';
import 'package:flutter_app/DataBase/database.dart';
import 'package:intl/intl.dart';

class CustomTodoAlert extends StatelessWidget {
  TodoData  _data;
  VoidCallback _posPress,_negPress;
  String _alertType,_posTxt,_negTxt;
  CustomTodoAlert(this._data,this._alertType,this._negTxt,this._posTxt,this._negPress,this._posPress);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(_alertType,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Center(
                        child: Text(
                          "${_data.task}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                    "Date :   ${new  DateFormat.yMMMd().format(_data.date)} ",
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButton(
                      txt: _negTxt,
                      txtColor: Theme.of(context).accentColor,
                      color: Colors.white,
                      borderColor: Theme.of(context).accentColor,
                      onPressed: _negPress,
                    ),
                    CustomButton(
                      txt: _posTxt,
                      txtColor: Colors.white,
                      color: Theme.of(context).accentColor,
                      onPressed:_posPress,
                      borderColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
