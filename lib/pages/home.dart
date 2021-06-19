import 'package:flutter/material.dart';
import 'package:vax_app/widgets/bencard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  bool? _booking;
  String? _button = "Book";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  bool isChecked = false;

  void _redirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('redirect', true);
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
    setState(() {
      widget._booking = true;
    });
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

  @override
  void initState() {
    super.initState();
    _checkBooking();
  }

  @override
  Widget build(BuildContext context) {
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
            BenCard(name: "Suhas Thalanki", benID: "123456789", vaccineStatus: "Partially Vaccinated", vaccine: "COVAXIN",),
            BenCard(name: "Roopak Maddara", benID: "6969696969", vaccineStatus: "Not Vaccinated",),
            BenCard(name: "Sachin Shankar", benID: "4204204202", vaccineStatus: "Fully Vaccinated", vaccine: "BALLER",),
            BenCard(name: "Hariharisudan Whatever", benID: "987654321", vaccineStatus: "Partially Vaccinated", vaccine: "SPUTNIK",),
            SizedBox(height: 20,),
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
}
