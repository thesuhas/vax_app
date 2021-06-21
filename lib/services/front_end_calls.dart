import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/localdata.dart';

class FrontEndCalls{

  // Returns a list of pincodes with the given latitude and longitude received from the Location API
  Future<void> getPincodeList(double lat, double long) async{
    ApiCalls apiCalls = ApiCalls();
    List<dynamic> centersList = await apiCalls.getCenters(lat, long);
    List<String> pincodeList = [];
    centersList.forEach((element) {
      String pincode = element['pincode'].toString();
      if(pincodeList.contains(pincode) == false){
        pincodeList.add(pincode);
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('possiblePins', pincodeList);
  }

  // Sets the pincode list in the user object stored in local storage to the user's choices of pincodes
  Future<void> setPincodeList(List<String> pinList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = prefs.getString('user').toString();
    User user = getUser(strUser);
    List<int> pinSave = [];
    pinList.forEach((element) {
      pinSave.add(int.parse(element));
    });
    user.setPinList(pinSave);
    String strUserNew = user.saveUser();
    prefs.setString('user', strUserNew);
    print("Saved $pinSave");
  }

  // Sets the phone number of the user to the user object in local storage
  Future<void> setPhoneNumber(int phNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(phNo: phNo);
    String strUser = user.saveUser();
    prefs.setString('user', strUser);
  }

  Future<void> benListToStringAndStore(List<Beneficiary> benList) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> benListStr = [];
    benList.forEach((element) {
      String ben = element.saveBen();
      benListStr.add(ben);
    });
    prefs.setStringList('benList', benListStr);
  }

  List<Beneficiary> benStrToObj(List<String> benListStr){
    List<Beneficiary> benObjList = [];
    benListStr.forEach((element) {
      Beneficiary oneBen = getBen(element);
      benObjList.add(oneBen);
    });
    return benObjList;
  }

}
