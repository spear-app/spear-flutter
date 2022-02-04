import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/shared/costant.dart';

Widget customRoundedButton(String text, Size size, Function()? function) => ElevatedButton(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(text, style: TextStyle(fontSize: 20)),
    ),
    style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(size),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(orange),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: orange)))),
    onPressed: function
);
