import 'package:flutter/material.dart';
import 'package:vax_app/pages/home.dart';
import 'package:vax_app/pages/setup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => Home(),
        '/setup': (context) => Setup(), 
      },
    );
  }
}

