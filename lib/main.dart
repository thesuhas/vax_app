import 'package:flutter/material.dart';
import 'package:vax_app/pages/welcome.dart';
import 'package:vax_app/pages/setup.dart';
import 'package:vax_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Welcome(),
      '/setup': (context) => Setup(),
      '/home': (context) => Home(),
    },
  ));
}

