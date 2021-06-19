import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BenCard extends StatefulWidget {

  // State Variables
  String? name;
  String? benID;
  String? vaccineStatus;
  String? vaccine; // To be passed only if at least first dose has been received

  // Constructor
  BenCard({required this.name, required this.benID, required this.vaccineStatus, this.vaccine});

  @override
  _BenCardState createState() => _BenCardState();
}

class _BenCardState extends State<BenCard> {

  bool? isChecked = false;

  Color? status;

  void setColor() {
    if (widget.vaccineStatus == "Fully Vaccinated") {
      status = Colors.green;
    }
    else if (widget.vaccineStatus == "Partially Vaccinated") {
      status = Colors.blue[700];
    }
    else {
      status = Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    setColor();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${widget.name}",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Text(
                  "Vaccinated: ",
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  "${widget.vaccineStatus}",
                  style: TextStyle(
                    color: status,
                  ),
                ),
                Spacer(),
                if (widget.vaccine != null)
                  Text(
                    "Vaccine: ${widget.vaccine}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              "Beneficiary ID: ${widget.benID}",
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Text(
                  "Book:",
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
      color: Colors.amberAccent[200],
    );
  }
}
