import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


typedef OnItemSelectedDropDown = Function (String value);

class DropDownOTP extends StatefulWidget {

  final Function(String?) onValueSelected;
  List<String> pincodes;
  DropDownOTP({required this.onValueSelected, required this.pincodes});
  @override
  _DropDownOTPState createState() => _DropDownOTPState();
}

class _DropDownOTPState extends State<DropDownOTP> {
  OnItemSelectedDropDown? onItemSelected;

  String? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Container(
          margin: EdgeInsets.all(12),
          width: 200,
          decoration: BoxDecoration(
              color: Colors.amberAccent[200],
              borderRadius: BorderRadius.circular(20)
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: DropdownButton<String>(
            items: widget.pincodes.map<DropdownMenuItem<String>>((String value) {
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
                widget.onValueSelected(value);
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
