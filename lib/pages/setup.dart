  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  String? key;
  class Setup extends StatefulWidget {
    @override
    _SetupState createState() => _SetupState();
  }

  class _SetupState extends State<Setup> {
    // Text Controller to retrieve Text
    final myController = TextEditingController();


    Future _check() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.clear();
      key = pref.getString('phoneNumber');
        print(key);
      print("check called");
    }

     _save(String number) async {
      SharedPreferences sp = await SharedPreferences.getInstance();

      await sp.setString('phoneNumber', number);
      print("save called");
    }


    // Function to clear field on disposing widget
    @override
    void dispose() {
      myController.dispose();
      super.dispose();
    }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _check();
    // print(key);
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
                    controller: myController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(
                      color: Colors.amberAccent[200],
                    ),

                    decoration: InputDecoration(
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
                        // print(_check());
                        if (key==null)
                          {
                              // print(myController.text);
                              _save(myController.text);
                              // print(_check());
                          }
                        else
                          {
                            print(key);
                            print(myController.text);
                            print("Number already saved");
                            _check();
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