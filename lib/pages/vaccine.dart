import 'package:flutter/material.dart';
import 'package:vax_app/services/localdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/front_end_calls.dart';

class Vaccine extends StatefulWidget {
  @override
  _VaccineState createState() => _VaccineState();
}

class _VaccineState extends State<Vaccine> {

  bool? redirect;

  void _checkRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    redirect = prefs.getBool('redirect');
    if (redirect == null)
    {
      redirect = false;
    }
  }

  void _setRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    redirect = prefs.getBool('redirect');
    if (redirect == true)
    {
      redirect = false;
      prefs.setBool('redirect', false);
    }
  }

  List<String> vaccines = [
    'ANY',
    'COVAXIN',
    'COVISHIELD',
  ];

  String? _vaccine;
  bool chosen = true;
  late User user;
  List<Beneficiary> beneficiary = [];

  Future<void> _loadUser() async {
    //Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString('user').toString();
    user = getUser(_user);
    List<String>? ben = prefs.getStringList('benList');
    if (ben == null) {
      ben = [];
    }
    ben.forEach((element) {
      beneficiary.add(getBen(element));
    });
    print(beneficiary);
  }

  Future<void> save(String? vaccine) async {
    beneficiary.forEach((element) {
      if (element.isDoseOneDone == false) {
        element.vaccine = vaccine;
      }
    });
    FrontEndCalls frontEndCalls = FrontEndCalls();
    await frontEndCalls.benListToStringAndStore(beneficiary);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkRedirect();
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
      brightness: Brightness.dark,
      centerTitle: true,
      backgroundColor: Colors.grey[850],
    ),
    backgroundColor: Colors.grey[900],
    body: Center(
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        color: Colors.grey[900],
        child: ListView(
          children: <Widget>[
            Center(
              child: Text(
                "Choose Preferred Vaccine ",
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 50,),
            Column(
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
                    items: vaccines.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style:TextStyle(color:Colors.black),),
                      );
                    }).toList(),
                    value: _vaccine,
                    hint: Text(
                      "Choose a Vaccine",
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                    dropdownColor: Colors.amberAccent[200],
                    focusColor: Colors.amberAccent[200],
                    onChanged: (String? value) {
                      setState(() {
                        _vaccine = value;
                      });
                    },
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2,
                    ),

                  ),
                ),
                ]
            ),
            Center(
              child: Container(
                child: !chosen ? Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    "Please Choose a Vaccine",
                    style: TextStyle(
                      color: Colors.red[900],
                      fontSize: 20,
                    ),
                  ),
                ): SizedBox(height: 20,),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: TextButton(
                onPressed: () async {
                   if (_vaccine != ''&& _vaccine != null)
                     {
                       setState(() {
                         chosen = true;
                       });
                       await _loadUser();
                       await save(_vaccine);
                       print("Chosen Vaccine: $_vaccine");
                       if (redirect == false) {
                         Navigator.pushReplacementNamed(context, '/feetype');
                       }
                       else if (redirect == true) {
                         _setRedirect();
                         Navigator.pushReplacementNamed(context, '/home');
                       }
                     }
                   else {
                     setState(() {
                       chosen = false;
                     });
                   }
                },
                child: Text(
                    "Submit"
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amberAccent[200],
                  primary: Colors.black,
                  padding: EdgeInsets.all(10),
                  textStyle: TextStyle(
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Center(
              child: Text(
                "Note: This applies only to Beneficiaries who have not taken their first dose yet.",
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontSize: 15,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
