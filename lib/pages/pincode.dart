import 'package:flutter/material.dart';
import 'package:vax_app/widgets/dropdown_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/front_end_calls.dart';

class PinCode extends StatefulWidget {

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {

  List<String>? pincodes;
  
  FrontEndCalls frontEndCalls = FrontEndCalls();


  // void _setUp () async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //prefs.setBool('isSetUp', true);
  //   //print("Set");
  // }

  bool? redirect;

  Set<String> toSet(List<String?> pins) {
    Set<String> pinsSet = {};
      pins.forEach((element) {
        if (element != null && element != '') {
          pinsSet.add(element);
        }
      });
    return pinsSet;
  }

  List<String> filterList(List<String?> pins) {
    List<String> filtered = [];
    pins.forEach((element) {
      if (element != '' && element != null) {
        filtered.add(element);
      }
    });
    return filtered;
  }

  void _checkRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    redirect = prefs.getBool('redirect');
    if (redirect == null)
    {
      redirect = false;
    }
  }

  void _setRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    redirect = prefs.getBool('redirect');
    if (redirect == true)
    {
      redirect = false;
      prefs.setBool('redirect', false);
    }
  }

  List<String> _nullPincodes(List<String>? pincodes) {
    if (pincodes == null || pincodes.length == 0)
      {
        pincodes = [];
      }
    return pincodes;
  }

  void _getPincodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pincodes = prefs.getStringList('possiblePins');
    });
  }
  
  List<String> _convert(List<String?> chosen) {
    List<String> converted = [];
    chosen.forEach((element) { 
      if (element != '' && element != null) {
        converted.add(element);
      }
    });
    if (converted.length == 0) {
      return [];
    }
    return converted;
  }

  // bool duplicate() {
  //   chosen.toSet().forEach((element) { });
  // }

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
  }

  @override
  void initState() {
    super.initState();
    _checkRedirect();
    _getPincodes();
  }

  @override
  Widget build(BuildContext context) {
    // data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    // print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CoVaccine",
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
                  pincodes: _nullPincodes(pincodes),
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[1] = value;
                    });
                  },
                  pincodes: _nullPincodes(pincodes),
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[2] = value;
                    });
                  },
                  pincodes: _nullPincodes(pincodes),
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[3] = value;
                    });
                  },
                  pincodes: _nullPincodes(pincodes),
                ),
                DropDownOTP(
                  onValueSelected: (value) {
                    setState(() {
                      chosen[4] = value;
                    });
                  },
                  pincodes: _nullPincodes(pincodes),
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
                        print("Chosen Pincodes: ${filterList(chosen).length}");
                        print("Chosen set: ${toSet(chosen)} ${toSet(chosen).length}");
                        //chosen.toSet().forEach((element) {print(element);});
                        // Validation of inputs
                        if (chosen.contains('') && chosen.where((element) => element == '').length == 5) {
                          setState(() {
                            isError = true;
                            errorText = "Pincodes not chosen";
                          });
                        }
                        else if (toSet(chosen).length != filterList(chosen).length) {
                          print("duplicate");
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

                          // Saving pincodes
                          frontEndCalls.setPincodeList(_convert(chosen));
                          //_setUp();
                          if (redirect == false) {
                            Navigator.pushReplacementNamed(
                                context, '/vaccine');
                          }
                          else if (redirect == true) {
                            _setRedirect();
                            Navigator.pushReplacementNamed(context, '/home');
                          }

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
