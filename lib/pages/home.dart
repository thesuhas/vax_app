import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/script.dart';
import 'package:telephony/telephony.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

backgroundMessageHandler(SmsMessage message) async {
  //Handle background message
  String? text = message.body;
  print("In handler:  $text");
}

class _HomeState extends State<Home> {

  String? number = '';
  String? txnId = '';
  String? otp = '';

  Automate aut = Automate(sessionId: "", slots: [""], centerId: "");

  final telephony = Telephony.instance;

  void getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('phoneNumber');
    });
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
    Future.delayed(Duration(seconds: 10), () {
      aut.automateSteps(txnId, otp);
    });
  }

  void _beneficiaries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isBen = prefs.getBool('isBen');
    Future.delayed(Duration(seconds: 12), () {
      print("entered");
      print(isBen);
      aut.beneficiaries();
    });
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      getNumber();
    });
    _listen();
    _validate();
    _beneficiaries();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VaxApp",
          style: TextStyle(
            color: Colors.amberAccent[200],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 40,),
          Container(
            padding: EdgeInsets.all(20),
            child: Text("Test"),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
