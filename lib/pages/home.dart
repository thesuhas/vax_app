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
  bool? inProcess;

  late List<String> beneficiaries;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FrontEndCalls frontEndCalls = FrontEndCalls();

  late User user;

  Map data = {};

  late List<Beneficiary> bens = [];
  StarterObject starter = StarterObject();

  List<Widget> widgets = [];

  SlotCheck slotCheck = SlotCheck();

  Future<void> loadBen() async {
    if (widget._booking == false || widget._booking == null) {
      widget.beneficiaries = await getBenListFromPrefs();
      bens = frontEndCalls.benStrToObj(widget.beneficiaries);
    }
  }
  
  bool benChecked(bool? checked) {
    if (checked == null) {
      return false;
    }
    return checked;
  }


  void _redirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('redirect', true);
  }

  void isChecked(bool? value, int index) {
    bens[index].isEnabled = value!;

  }

  void isCheckedNew(bool? value, Beneficiary beneficiary){
    beneficiary.isEnabled = value!;
  }

  Future<void> _checkBooking() async {
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

  bool checkSelect() {
    for (int i = 0; i < bens.length; i ++)
      {
        if (bens[i].isEnabled == true) {
          return true;
        }
      }
    return false;
  }

  void updateState() {
    setState(() {
      widget._booking = true;
      widget.inProcess = true;
    });
  }

  void _startBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('booking', true);
    await frontEndCalls.benListToStringAndStore(bens);
    if (widget._booking == false && widget.inProcess != true) {
      updateState();
    }
    String? status = await starter.startSearching();
    await _endBooking();
    _update();
    Navigator.pushReplacementNamed(context, '/loading');
  }

  Future<void> _endBooking() async {
    print("entered end");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('booking', false);
    starter.stopSearching();
    //if (widget.inProcess == true) {
    Navigator.pushReplacementNamed(context, '/home');
    //}
  }

  bool _checkBool(bool? test) {
    if (test == null || test == false) {
      return false;
    }
    return true;
  }

  Future<void> setup() async {
    String userStr = await getUserFromPrefs();
    user = getUser(userStr);
    await loadBen();
    await _checkBooking();
    await _resetUpdate();
    widgetBen();
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
      bens.forEach((ben) {
        widgets.add(BenCard(ben: ben, onSelect: (bool? test) {isCheckedNew(test, ben);}, user: user, checked: benChecked(ben.isEnabled),));
      });
    }

  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('updateBen', true);
  }

  Future<void> _resetUpdate() async {
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
        if (snapshot.connectionState != ConnectionState.done && widget.inProcess == false) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amberAccent[200],
            ),
          );
        }
        else {
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
                            _redirect();
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
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          "Change Fee Type",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          if (!_checkBool(widget._booking)) {
                            _redirect();
                            Navigator.pushReplacementNamed(context, '/feetype');
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
                          if (checkSelect()) {
                            if (!_checkBool(widget._booking)) {
                              _startBooking();
                            }
                          }
                          else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Beneficiaries not Selected'),
                                  content: const Text('Please select at least one Beneficiary before booking'),
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
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "IMPORTANT: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent[200],
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Text(
                            "Click Update Beneficiaries after receiving Vaccination",
                            style: TextStyle(
                              color: Colors.amberAccent[200],
                              fontSize: 20,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
