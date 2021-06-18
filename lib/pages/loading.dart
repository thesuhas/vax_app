import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/script.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/services.dart';

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
      // Future.delayed(Duration(seconds: 1), () {
      //   Navigator.pushReplacementNamed(context, '/home', arguments: {
      //     'beneficiaries': aut.ben,
      //   });
      //});
      Navigator.pushReplacementNamed(context, '/pincode');
    });
  }

  @override
  void initState () {
    super.initState();
    _listen();
    getNumber();
    _validate();
    _beneficiaries();
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
