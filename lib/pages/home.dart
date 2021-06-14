import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatelessWidget {
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
            FlatButton.icon(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/setup');
              },
              color: Colors.amberAccent[200],
              icon: Icon(Icons.navigate_next),
              label: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
