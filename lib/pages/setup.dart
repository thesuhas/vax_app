  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class Setup extends StatefulWidget {
    @override
    _SetupState createState() => _SetupState();
  }

  class _SetupState extends State<Setup> {
    // Text Controller to retrieve Text
    final myController = TextEditingController();
    bool _validate = false;

    // Saving data
    Future _save(String number) async{
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('phoneNumber', number);
      pref.setBool('isSetUp', true);
    }

    Future _check() async {
      print("Check called");
      SharedPreferences pref = await SharedPreferences.getInstance();
      print(pref.get('phoneNumber'));
    }

    Future _clear() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
    }

    // Function to clear field on disposing widget
    @override
    void dispose() {
      myController.dispose();
      super.dispose();
    }
    @override
  void initState() {
    super.initState();
    //_clear();
  }

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
          child: ListView(
            children: <Widget>[
              SizedBox(height: 90,),
              Icon(
                Icons.medication,
                size: 250,
                color: Colors.amberAccent[200],
              ),
              SizedBox(height: 50,),
              Center(
                child: Text(
                  'Enter Mobile Number',
                  style: TextStyle(
                    color: Colors.amberAccent[200],
                    letterSpacing: 2,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    maxLengthEnforced: true,
                    controller: myController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                    ),
                    decoration: InputDecoration(
                      errorText: _validate ? 'Enter a valid Phone Number' : null,
                      counterText: "",
                      prefix: Text(
                          "+91",
                        style: TextStyle(
                          color: Colors.amberAccent[200]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                child: Center(
                  child: SizedBox(
                    width: 100,
                    child: FlatButton(
                      onPressed: () {
                        if (myController.text.length < 10 || myController.text.isEmpty)
                          {
                            setState(() {
                              _validate = true;
                            });
                          }
                        else {
                          setState(() {
                            _validate = false;
                          });
                          _save(myController.text);
                          //_check();
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: Text(
                        'Submit'
                      ),
                      color: Colors.amberAccent[200],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }