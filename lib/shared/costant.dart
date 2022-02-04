import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color orange = Color(0xFFEE6F57);
Color blue = Color(0xFF145374);
Color backgroundColor = Color(0xFFF6F5F5);
Function()? push (context, screen)=>()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> screen));