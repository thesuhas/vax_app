import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/script.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? number = '';

  Automate aut = Automate(sessionId: "", slots: [""], centerId: "");


  void getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('phoneNumber');
    });
  }

  void _listen() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getNumber();
    });
    _listen();
    aut.automateOtp();
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
            child: PinFieldAutoFill(
              decoration: UnderlineDecoration(
                textStyle: TextStyle(
                  color: Colors.amberAccent[200],
                ),
                colorBuilder: FixedColorBuilder(
                  Colors.grey,
                ),
              ),
              onCodeSubmitted: (otp) {
                print(otp);
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
