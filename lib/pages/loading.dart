import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:vax_app/services/store_data.dart';
import 'package:location/location.dart';
import 'package:vax_app/services/front_end_calls.dart';



class LoadingData extends StatefulWidget {
  @override
  _LoadingDataState createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData> {

  String? number = '';
  String? otp;

  FrontEndCalls frontEndCalls = FrontEndCalls();

  StoreData storeData = StoreData();

  final telephony = Telephony.instance;

  bool? isUpdate;


  void _beneficiaries() async {
    await storeData.getAndSaveData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isBen = prefs.getBool('isBen');
    Future.delayed(Duration(seconds: 7), () {
      //print(isBen);
      // aut.beneficiaries();
      if (isUpdate == true) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      else {
        Navigator.pushReplacementNamed(context, '/pincode');
      }
    });
  }


  Future<void> _location() async {
    Location location = new Location();
    LocationData _location;
    // Get service if necessary
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      print("Location Service: $_serviceEnabled");
    }
    // Permissions
    PermissionStatus _permissionsGranted = await location.hasPermission();
    if (_permissionsGranted == PermissionStatus.denied) {
      _permissionsGranted = await location.requestPermission();
      print("Permissions: $_permissionsGranted");
    }

    // Get the location
    _location = await location.getLocation();

    await frontEndCalls.getPincodeList(double.parse(_location.latitude.toString()), double.parse(_location.longitude.toString()));
  }

  void _isUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isUpdate = prefs.getBool('updateBen');
    if (isUpdate == null) {
      isUpdate = false;
    }
  }

  void loadSetUp() async {
    await _location();
    _beneficiaries();
  }

  @override
  void initState () {
    super.initState();
    _isUpdate();
    loadSetUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Getting required data",
                style: TextStyle(
                  color: Colors.amberAccent[200],
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 40,),
              CircularProgressIndicator(
                color: Colors.amberAccent[200],
              ),
            ],
          ),
        ),
    );
  }
}
