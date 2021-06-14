import 'package:flutter/material.dart';
import 'package:vax_app/pages/home.dart';
import 'package:vax_app/pages/setup.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(),
      '/setup': (context) => Setup(),
    },
  ));
}

