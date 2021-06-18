import 'package:flutter/material.dart';
import 'package:vax_app/pages/welcome.dart';
import 'package:vax_app/pages/setup.dart';
import 'package:vax_app/pages/home.dart';
import 'package:vax_app/pages/loading.dart';
import 'package:vax_app/pages/pincode.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  bool? isSetUp = prefs.getBool('isSetUp');
  //print(isSetUp);
  String initialRoute;
  if (isSetUp == true)
    {
      initialRoute = '/pincode';
    }
  else {
    initialRoute = '/welcome';
  }
  //print(initialRoute);
  runApp(MaterialApp(
    initialRoute: initialRoute,
    routes: {
      '/welcome': (context) => Welcome(),
      '/setup': (context) => Setup(),
      '/home': (context) => Home(),
      '/pincode': (context) => PinCode(),
      '/loading': (context) => LoadingData(),
    },
  ));
}

