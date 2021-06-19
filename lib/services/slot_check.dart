import 'localdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlotCheck{

  List<String>? benList = [];

  dynamic slotCheck() {
  DateTime tomorrowDate = DateTime.now().add(Duration(days: 1));
  DateTime dayAfterDate = DateTime.now().add(Duration(days: 2));
  String tomorrow = "${tomorrowDate.day}-${tomorrowDate.month}-${tomorrowDate.year}";
  String dayAfter = "${dayAfterDate.day}-${dayAfterDate.month}-${dayAfterDate.year}";
  List<String> dates = [tomorrow, dayAfter];
  // seshList = api call findByPin
    // 3 bens, 1 user
    // list.foreach: call a distribute function..
    // distribute: isDoseOnedone -> what vaccine he wants -> 28-84 days check-> check if it's in the sehslist ->


  }



  Future<void> getBenList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? benLis = pref.getStringList('benList');
    benList = benLis;
  }


}