import 'package:flutter/material.dart';

class DropDownOTP extends StatefulWidget {
  @override
  _DropDownOTPState createState() => _DropDownOTPState();
}

class _DropDownOTPState extends State<DropDownOTP> {

  String? _value = null;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Container(
          decoration: BoxDecoration(
              color: Colors.amberAccent[200],
              borderRadius: BorderRadius.circular(20)
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: DropdownButton<String>(
            items: <String>[
              '50001',
              '50002',
              '50003',
              '50004',
              '50005',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style:TextStyle(color:Colors.black),),
              );
            }).toList(),
            value: _value,
            hint: Text(
              "Choose a Pincode",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            dropdownColor: Colors.amberAccent[200],
            focusColor: Colors.amberAccent[200],
            onChanged: (String? value) {
              setState(() {
                _value = value;
              });
            },
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2,
            ),

          ),
        ),
        ]
    );
  }
}
