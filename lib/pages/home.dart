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
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[850],
      body: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          Container(
            child: Center(
              child: Icon(
                  Icons.medication,
                  size: 150,
                  color: Colors.amberAccent[200],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
