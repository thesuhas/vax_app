import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/localdata.dart';

class FrontEndCalls{


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

  Future<void> setPincodeList(List<int> pinList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = prefs.getString('user').toString();
    User user = getUser(strUser);
    user.setPinList(pinList);
    String strUserNew = user.saveUser();
    prefs.setString('user', strUserNew);
  }

}
