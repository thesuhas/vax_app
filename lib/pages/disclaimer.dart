import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
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
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  "DISCLAIMER",
                  style: TextStyle(
                    color: Colors.amberAccent[200],
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 4,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                "1. By agreeing, you are giving us permission to access your location (ONLY once) to get the pincodes nearest to you.\n\n"
                    "2. You will also be giving us access to read your incoming messages so as to automate CoWIN authentication.\n\n"
                    "3. Your data will not be misused and is not being sent anywhere, any data being accessed by us is being stored locally and even the developers cannot access it.\n\n"
                    "If you have any queries, please let us know at covidindiabot@gmail.com",
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 2,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 25,),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/setup");
                  },
                  child: Text(
                    "I agree"
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
            ],
          ),
        ),
      ),
    );
  }
}
