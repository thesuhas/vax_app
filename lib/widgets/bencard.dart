import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vax_app/services/localdata.dart';

class BenCard extends StatefulWidget {

  final Function(bool?) onSelect;

  // State Variables
  // String? name;
  // String? benID;
  // String? vaccineStatus;
  // String? vaccine; // To be passed only if at least first dose has been received
  late Beneficiary ben;

  late User user;

  // Constructor
  BenCard({required this.ben, required this.onSelect, required this.user});

  @override
  _BenCardState createState() => _BenCardState();
}

class _BenCardState extends State<BenCard> {

  bool? isChecked = false;

  Color? status;

  bool dueDateCheck() {
    DateTime now = DateTime.now();
    if (widget.ben.isDoseOneDone == true) {
      List dmyList = widget.ben.doseOneDate.toString().split('-');
      //print(dmyList);
      DateTime doseOneDate = DateTime.utc(int.parse(dmyList[2]), int.parse(dmyList[1]), int.parse(dmyList[0]));
      if (widget.ben.vaccine == "COVAXIN") {
        return now.isAfter(doseOneDate.add(Duration(days: 27)));
      }
      else if (widget.ben.vaccine == 'COVISHIELD') {
        return doseOneDate.isAfter(now.add(Duration(days: 83)));
      }
    }
    return false;
  }

  String returnEligible() {
    DateTime now = DateTime.now();
    List dmyList = widget.ben.doseOneDate.toString().split('-');
    //print(dmyList);
    DateTime doseOneDate = DateTime.utc(int.parse(dmyList[2]), int.parse(dmyList[1]), int.parse(dmyList[0]));
    String date;
    if (widget.ben.vaccine == "COVAXIN") {
      DateTime due = doseOneDate.add(Duration(days: 27));
      date = "${due.day}-${due.month}-${due.year}";
    }
    else {
      DateTime due = doseOneDate.add(Duration(days: 83));
      date = "${due.day}-${due.month}-${due.year}";
    }
    return date;
  }

  void setColor() {
    if (widget.ben.vaccinationStatus == "Fully Vaccinated") {
      status = Colors.green;
    }
    else if (widget.ben.vaccinationStatus == "Partially Vaccinated") {
      status = Colors.blue[700];
    }
    else {
      status = Colors.red;
    }
  }

  String getFeeType() {
    if (widget.user.wantFree == true && widget.user.wantPaid == false) {
      return "Free";
    }
    else if (widget.user.wantPaid == true && widget.user.wantFree == false) {
      return "Paid";
    }
    else {
      return "Any";
    }
  }

  List<Widget> checkOrSlip() {
     if (widget.ben.bookedSlot == true && widget.ben.isDoseTwoDone == false) {
       return <Widget>[
         TextButton(
           onPressed: (){},
           child: Text(
               "Appointment Slip"
           ),
           style: TextButton.styleFrom(
             backgroundColor: Colors.grey[900],
             primary: Colors.amberAccent[200],
             textStyle: TextStyle(
               letterSpacing: 2,
             ),
           ),
         )
       ];
    }
    else  {
       if ((widget.ben.vaccinationStatus == "Partially Vaccinated" && dueDateCheck() == true) || (widget.ben.vaccinationStatus == "Not Vaccinated" && widget.ben.bookedSlot == false)) {
         return <Widget>[
           Container(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: Row(
               children: <Widget>[
                 Text(
                   "Book:",
                   style: TextStyle(
                     color: Colors.grey[800],
                   ),
                 ),
                 SizedBox(
                   height: 24,
                   child: Checkbox(
                     value: isChecked,
                     onChanged: (bool? value) {
                       setState(() {
                         isChecked = value!;
                       });
                       widget.onSelect(value!);
                     },
                     activeColor: Colors.black,
                   ),
                 ),

               ],
             ),
           ),
         ];
       }
       else if (widget.ben.vaccinationStatus != "Not Vaccinated") {
         return <Widget>[
           Container(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: Text(
               "Eligible from: ${returnEligible()}",
               style: TextStyle(
                  color: Colors.grey[800],
                 fontWeight: FontWeight.bold,
               ),
             ),
           ),
         ];
       }
       else {
         return <Widget>[
           Container(
             padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
             child: Row(
               children: <Widget>[
                 Text(
                   "Book:",
                   style: TextStyle(
                     color: Colors.grey[800],
                   ),
                 ),
                 SizedBox(
                   height: 24,
                   child: Checkbox(
                     value: isChecked,
                     onChanged: (bool? value) {
                       setState(() {
                         isChecked = value!;
                       });
                       widget.onSelect(value!);
                     },
                     activeColor: Colors.black,
                   ),
                 ),

               ],
             ),
           ),
         ];
       }
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
              "${widget.ben.beneficiaryName}",
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
                  "${widget.ben.vaccinationStatus}",
                  style: TextStyle(
                    color: status,
                  ),
                ),
                Spacer(),
                if (widget.ben.vaccine != null)
                  Text(
                    "Vaccine: ${widget.ben.vaccine}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10,),
            Text(
              "Beneficiary ID: ${widget.ben.beneficiaryId}",
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10,),
            Text(
              "Fee Type: ${getFeeType()}",
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: checkOrSlip(),
            ),
          ],
        ),
      ),
      color: Colors.amberAccent[200],
    );
  }
}
