import 'package:flutter/material.dart';
import 'package:vax_app/widgets/dropdown_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCode extends StatefulWidget {

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {

  List<String> pincodes = [
    '50001',
    '50002',
    '50003',
    '50004',
    '50005',
  ];

  void _setUp () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSetUp', true);
    print("Set");
  }

  bool isError = false;
  String errorText = '';

  List<String?> chosen = [
    '',
    '',
    '',
    '',
    '',
  ];

  @override
  void dispose () {
    super.dispose();
    setState(() {
      errorText = '';
      isError = false;
      chosen = [
        '',
        '',
        '',
        '',
        '',
      ];
    });
  }

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
                    "Choose Preferred PinCodes",
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[0] = value;
                    });
                  },
                  pincodes: pincodes,
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[1] = value;
                    });
                  },
                  pincodes: pincodes,
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[2] = value;
                    });
                  },
                  pincodes: pincodes,
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[3] = value;
                    });
                  },
                  pincodes: pincodes,
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[4] = value;
                    });
                  },
                  pincodes: pincodes,
                ),
                Center(
                  child: Container(
                    child: isError ? Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "$errorText",
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 20,
                        ),
                      ),
                    ): SizedBox(height: 20,),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        print("Chosen Pincodes: $chosen");
                        // Validation of inputs
                        if (chosen.contains('') && chosen.where((element) => element == '').length == 5) {

                          setState(() {
                            isError = true;
                            errorText = "Pincodes not chosen";
                          });
                        }
                        else if (chosen.toSet().toList().length != chosen.length && !chosen.toSet().toList().contains('')) {
                          setState(() {
                            errorText = "Duplicate pincodes chosen";
                            isError = true;
                          });
                        }
                        else {
                          if (isError) {
                            setState(() {
                              isError = false;
                            });
                          }
                          _setUp();
                          Navigator.pushReplacementNamed(context, '/vaccine');
                        }
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
