import 'package:flutter/material.dart';
import 'package:vax_app/widgets/dropdown_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCode extends StatefulWidget {

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {

  void _setUp () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSetUp', true);
    print("Set");
  }

  String? chosen1;
  String? chosen2;
  String? chosen3;
  String? chosen4;
  String? chosen5;

  @override
  Widget build(BuildContext context) {
    // data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    // print(data);
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
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    "Choose Preferred OTPs",
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen1 = value;
                    });
                  }
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen2 = value;
                    });
                  },
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen3 = value;
                    });
                  },
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen4 = value;
                    });
                  },
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen5 = value;
                    });
                  },
                ),
                SizedBox(height: 40,),
                Center(
                  child: Container(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        print("Chosen Pincodes: $chosen1, $chosen2, $chosen3, $chosen4, $chosen5");
                        _setUp();
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text(
                        "Submit"
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amberAccent[200],
                        primary: Colors.black,
                        textStyle: TextStyle(
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
        ),
      );
  }
}
