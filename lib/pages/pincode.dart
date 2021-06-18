import 'package:flutter/material.dart';
import 'package:vax_app/widgets/dropdown_otp.dart';

class PinCode extends StatefulWidget {
  const PinCode({Key? key}) : super(key: key);

  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {

  //Map data = {};
  List<String> pincodes = [
    '50001',
    '50002',
    '50003',
    '50004',
    '50005',
  ];

  List<String?> selected = [
    null,
    null,
    null,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    // data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    // print(data);
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
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
              children: <Widget>[
                DropDownOTP(),
              ],
            ),
        ),
        ),
      );
  }
}
