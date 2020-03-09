import 'package:flutter/material.dart';

const bottomNavBackgroundColor = Color.fromRGBO(150, 151, 153, 1);
const double bottomNavElevation = 4;
const bottomNavSelectedItemColor = Colors.white;
const bottomNavUnselectedItemColor = Colors.black38;

var themeData = ThemeData(
  primarySwatch: Colors.lightGreen,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
);
