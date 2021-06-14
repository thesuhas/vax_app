import 'package:flutter/material.dart';
import 'package:vax_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(),
    },
  ));
}

