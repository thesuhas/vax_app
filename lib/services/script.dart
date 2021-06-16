import 'dart:convert';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Automate{

  // Required Arguments
  late String sessionId;
  late List<String> slots;
  late String centerId;


  Map<String, String> headers = {
    'Accept-Language': 'en-IN',
    'Content-Type': 'application/json',
    'origin': 'https://selfregistration.cowin.gov.in/',
    'referer': 'https://selfregistration.cowin.gov.in/',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
  };

  late Steps step = Steps(headers: headers);


  // Binding
  Automate( {required this.sessionId, required this.slots, required this.centerId} );

  // String? txnId;


  Future<String?> automateOtp() async{
    // String? txnId = await step.getOtp();
    // print(txnId);
    String txnId = await step.getOtp();
    print(txnId);
    return txnId;
  }



  Future<String?> automateSteps(String? txnId, String? otp) async{
    String? token = await step.validate(otp, txnId);
    Map<String, String> newHeaders = step.setNewHeaders(token);
    print(newHeaders);
  }

   Future<String?> beneficiaries() async{
    print("entered automate ben");
    await step.getBen();
  }

}

class Steps{

  // Variables supplied
  Map<String, String> headers;

  // Binding
  Steps( {required this.headers} );

  // Variables set in this object
  // String? txnId;


  Future<String> getOtp () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = 'https://cdn-api.co-vin.in/api/v2/auth/generateMobileOTP';
    Object? data = {
      'mobile': prefs.get('phoneNumber'),
      'secret': 'U2FsdGVkX19PaSqxnwmqk4McfhXokocQjLHrFbskUpcV64Aoq564fJKZ6h5X4fF9iLxBavMj4znDjeIcyNfxJw=='
    };
    Response response = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    var resp = jsonDecode(response.body);
    return resp['txnId'];
  }

  Future<String>? validate(String? otp, String? txnId) async{
    String url = 'https://cdn-api.co-vin.in/api/v2/auth/validateMobileOtp';
    if (otp == null)
      {
        otp = "";
      }
    Digest encodedOtp = sha256.convert(utf8.encode(otp));
    Object? data = {
      'otp': encodedOtp.toString(),
      'txnId': txnId
    };
    Response response = await post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    var resp = jsonDecode(response.body);
    print(resp);
    // print(resp['token']);
    return resp['token'];
  }

  Map<String, String> setNewHeaders(String? token) {
    headers['Authorization'] = 'Bearer $token';
    // headers.addAll('Authorization': 'Bearer $token');
    return headers;
  }

  Future<String?> getBen() async{
    String url = "https://cdn-api.co-vin.in/api/v2/appointment/beneficiaries";

    Response response = await get(
        Uri.parse(url),
        headers: headers
    );
    var resp = jsonDecode(response.body);
    print(resp['beneficiaries']);
    print(resp['beneficiaries'].runtimeType);
  }
}