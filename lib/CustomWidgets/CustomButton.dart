import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color txtColor;
  final Color borderColor;
 final  String txt;
  CustomButton({ this.onPressed,
    this.color,
    this.txtColor,
    this.borderColor,
    this.txt,});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: txtColor,
      padding: EdgeInsets.all(14),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      onPressed: onPressed,
      child: Text(txt),
      color: color,
    );
  }
}



