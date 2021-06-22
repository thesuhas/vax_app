import 'package:flutter/material.dart';
import 'package:vax_app/services/localdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/front_end_calls.dart';
import 'package:vax_app/services/store_data.dart';

class FeeType extends StatefulWidget {
  @override
  _FeeTypeState createState() => _FeeTypeState();
}

class _FeeTypeState extends State<FeeType> {

  List<String> feeTypes = [
    'Any',
    'Free',
    'Paid',
  ];

  String? _feeType;
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

  Future<void> save(String? feeType) async {
    if (feeType != null) {
      if (feeType == 'Paid') {
        user.wantFree = false;
        user.wantPaid = true;
      }
      else if (feeType == 'Free') {
        user.wantPaid = false;
        user.wantFree = true;
      }
      else {
        user.wantPaid = true;
        user.wantFree = true;
      }
    }
    String userStr = user.saveUser();
    await setUserToPrefs(userStr);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                  "Choose Preferred Fee Type ",
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
                    width: 220,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent[200],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: DropdownButton<String>(
                      items: feeTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style:TextStyle(color:Colors.black),),
                        );
                      }).toList(),
                      value: _feeType,
                      hint: Text(
                        "Choose a Fee Type",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                      dropdownColor: Colors.amberAccent[200],
                      focusColor: Colors.amberAccent[200],
                      onChanged: (String? value) {
                        setState(() {
                          _feeType = value;
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
                      "Please Choose a Fee Type",
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
                    if (_feeType != ''&& _feeType != null)
                    {
                      setState(() {
                        chosen = true;
                      });
                      await _loadUser();
                      await save(_feeType);
                      print("Chosen Fee Type: $_feeType");
                      Navigator.pushReplacementNamed(context, '/home');
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
            ],
          ),
        ),
      ),
    );
  }
}
