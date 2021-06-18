import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Welcome extends StatelessWidget {
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 90,),
            Icon(
                Icons.medication,
                size: 250,
                color: Colors.amberAccent[200],
            ),
            SizedBox(height: 90,),
            TextButton.icon(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/setup');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.amberAccent[200],
                primary: Colors.black,
                textStyle: TextStyle(
                  letterSpacing: 0,
                ),
              ),
              icon: Icon(Icons.navigate_next),
              label: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
