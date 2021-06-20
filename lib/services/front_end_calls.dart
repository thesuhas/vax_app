import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/localdata.dart';

class FrontEndCalls{

  // Returns a list of pincodes with the given latitude and longitude received from the Location API
  Future<List<int>> getPincodeList(double lat, double long) async{
    ApiCalls apiCalls = ApiCalls();
    List<dynamic> centersList = await apiCalls.getCenters(lat, long);
    List<int> pincodeList = [];
    centersList.forEach((element) {
      int pincode = int.parse(element['pincode']);
      if(pincodeList.contains(pincode) == false){
        pincodeList.add(pincode);
      }
    });
    return pincodeList;
  }

  // Sets the pincode list in the user object stored in local storage to the user's choices of pincodes
  Future<void> setPincodeList(List<int> pinList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = prefs.getString('user').toString();
    User user = getUser(strUser);
    user.setPinList(pinList);
    String strUserNew = user.saveUser();
    prefs.setString('user', strUserNew);
  }

  // Sets the phone number of the user to the user object in local storage
  Future<void> setPhoneNumber(int phNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(phNo: phNo);
    String strUser = user.saveUser();
    prefs.setString('user', strUser);
  }

}
