import 'package:flutter/material.dart';
import 'package:vax_app/services/store_data.dart';
import 'package:vax_app/widgets/bencard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/localdata.dart';
import 'package:vax_app/services/front_end_calls.dart';
import 'package:vax_app/services/slot_check.dart';

class Home extends StatefulWidget {

  bool? _booking;
  String? _button = "Book";

  late List<String> beneficiaries;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FrontEndCalls frontEndCalls = FrontEndCalls();

  Map data = {};

  late List<Beneficiary> bens = [];

  List<Widget> widgets = [];

  SlotCheck slotCheck = SlotCheck();

  Future<void> loadBen() async {
    if (widget._booking == false || widget._booking == null) {
      widget.beneficiaries = await getBenListFromPrefs();
      bens = frontEndCalls.benStrToObj(widget.beneficiaries);
      //print(bens);
    }
  }


  void _redirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('redirect', true);
  }

  void isChecked(bool? value, int index) {
    bens[index].isEnabled = value!;
    //print("bencard ${bens[index].isEnabled} ${bens[index].beneficiaryName}");
  }

  void _checkBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget._booking = prefs.getBool('booking');
    if (widget._booking == null || widget._booking == false) {
      widget._booking = false;
    }
    else if (widget._booking == true) {
      setState(() {
        widget._button = "Booking";
      });
    }
  }

  void _startBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('booking', true);
    await frontEndCalls.benListToStringAndStore(bens);
    setState(() {
      widget._booking = true;
    });
    await slotCheck.initialise();
    String? status = await slotCheck.slotCheck();
    print(status);
  }

  void _endBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('booking', false);
    setState(() {
      widget._booking = false;
    });
  }

  bool _checkBool(bool? test) {
    if (test == null || test == false) {
      return false;
    }
    return true;
  }

  Future<void> setup() async {
    await loadBen();
    _checkBooking();
    _resetUpdate();
  }

  void widgetBen () {
    widgets = [];
    if (bens.length == 0) {
      widgets.add(Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text(
            "You have not registered any beneficiaries on the CoWIN site. Please do so and Update Beneficiaries after.",
            style: TextStyle(
              color: Colors.amberAccent[200],
              letterSpacing: 2,
              fontSize: 20,
            ),
          textAlign: TextAlign.center,
        ),
      ));
    }
    else {
      for (int i = 0; i < bens.length; i ++) {
        widgets.add(BenCard(name: bens[i].beneficiaryName, benID: bens[i].beneficiaryId.toString(), vaccineStatus: bens[i].vaccinationStatus, vaccine: bens[i].vaccine, onSelect: (bool? test) {isChecked(test, i);},),);
      }
    }

  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('updateBen', true);
  }

  void _resetUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('updateBen', false);
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          widgetBen();
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
            drawer: Drawer(
              child: Container(
                color: Colors.grey[900],
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: DrawerHeader(

                        child: Text(
                          "Pages",
                          style: TextStyle(
                            color: Colors.amberAccent[200],
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          "Change Pincodes",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          if (!_checkBool(widget._booking)) {
                            _redirect();
                            Navigator.pushReplacementNamed(context, '/pincode');
                          }
                          else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Booking in Progress'),
                                  content: const Text('Cannot change Pincode during Booking'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                  backgroundColor: Colors.amberAccent[200],
                                )
                            );
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amberAccent[200],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          "Change Vaccine",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          if (!_checkBool(widget._booking)) {
                            Navigator.pushReplacementNamed(context, '/vaccine');
                          }
                          else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Booking in Progress'),
                                  content: const Text('Cannot change Vaccine Preference during Booking'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                  backgroundColor: Colors.amberAccent[200],
                                )
                            );
                          }
                        },
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.amberAccent[200],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey[900],
            body: Container(
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, !_checkBool(widget._booking) ? 0 : 20, 10, 10),
                      child: !_checkBool(widget._booking)  ?
                      SizedBox(height: 0, width: 0,):
                      Text(
                        "Booking in Progress",
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: widgets,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    width: 150,
                    child: Center(
                      child: !_checkBool(widget._booking) ? TextButton.icon(
                        onPressed: () {
                          _update();
                          Navigator.pushReplacementNamed(context, '/loading');
                        },
                        label: Text(
                            "Update Beneficiaries"
                        ),
                        icon: Icon(Icons.refresh),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amberAccent[200],
                          primary: Colors.black,
                          textStyle: TextStyle(
                            letterSpacing: 2,
                          ),
                        ),
                      ): SizedBox(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    width: !_checkBool(widget._booking) ? 50 : 100,
                    child: Center(
                      child: !_checkBool(widget._booking) ? TextButton(
                        onPressed: () {
                          if (!_checkBool(widget._booking)) {
                            _startBooking();
                          }
                        },
                        child: Text(
                            "Book"
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amberAccent[200],
                          primary: Colors.black,
                          textStyle: TextStyle(
                            letterSpacing: 2,
                          ),
                        ),
                      ) : TextButton(
                        onPressed: () {
                          if (_checkBool(widget._booking)) {
                            _endBooking();
                          }
                        },
                        child: Text(
                            "End Booking"
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
          );
        }
      },

    );
  }
}
