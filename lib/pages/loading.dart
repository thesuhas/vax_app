import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/script.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

backgroundMessageHandler(SmsMessage message) async {
  //Handle background message
  String? text = message.body;
  print("In handler:  $text");
}

class LoadingData extends StatefulWidget {
  @override
  _LoadingDataState createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData> {

  String? number = '';
  String? otp = '';

  Automate aut = Automate(sessionId: "", slots: [""], centerId: "");

  final telephony = Telephony.instance;

  void getNumber() async {
    // Get Shared Preferences to extract Data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('phoneNumber');
    });
    // Create telephony instance to listen for phone number
  }

  void _listen() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    telephony.listenIncomingSms(
      onNewMessage: (message) {
        String? text = message.body?.substring(37, 43);
        setState(() {
          otp = text;
        });
      },
      onBackgroundMessage: backgroundMessageHandler,
      listenInBackground: true,
    );
  }

  void _validate() async {
    String? txnId =  await aut.automateOtp();
    Future.delayed(Duration(seconds: 5), () {
      aut.automateSteps(txnId, otp);
    });
  }

  void _beneficiaries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isBen = prefs.getBool('isBen');
    Future.delayed(Duration(seconds: 6), () {
      print("entered");
      //print(isBen);
      aut.beneficiaries();
      Navigator.pushReplacementNamed(context, '/pincode');
    });
  }

  void _location() async {
    Location location = new Location();
    LocationData _location;
    // Get service if necessary
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print("Location Service: $_serviceEnabled");
    }
    // Permissions
    PermissionStatus _permissionsGranted = await location.hasPermission();
    if (_permissionsGranted == PermissionStatus.denied) {
      _permissionsGranted = await location.requestPermission();
      print("Permissions: $_permissionsGranted");
    }

    // Get the location
    _location = await location.getLocation();
    print("Location: $_location");
  }


  @override
  void initState () {
    super.initState();
    _listen();
    getNumber();
    _validate();
    _beneficiaries();
    _location();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: CircularProgressIndicator(),
        ),
    );
  }
}