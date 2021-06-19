import 'package:flutter/material.dart';
import 'package:vax_app/widgets/bencard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
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
                    _redirect();
                    Navigator.pushReplacementNamed(context, '/pincode');
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
                    Navigator.pushReplacementNamed(context, '/vaccine');
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
            BenCard(name: "Suhas Thalanki", benID: "123456789", vaccineStatus: "Partially Vaccinated", vaccine: "COVAXIN",),
            BenCard(name: "Roopak Maddara", benID: "6969696969", vaccineStatus: "Not Vaccinated",),
            BenCard(name: "Sachin Shankar", benID: "4204204202", vaccineStatus: "Fully Vaccinated", vaccine: "BALLER",),
            BenCard(name: "Hariharisudan Whatever", benID: "987654321", vaccineStatus: "Partially Vaccinated", vaccine: "SPUTNIK",),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              width: 50,
              child: Center(
                child: TextButton(
                  onPressed: () {},
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
