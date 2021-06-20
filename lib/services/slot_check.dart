import 'localdata.dart';
import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:vax_app/services/store_data.dart';

class SlotCheck{

  List<String> benList;
  User user;

  SlotCheck( {
    required this.benList,
    required this.user
} );

  Future<void> initialise() async {
    await getUserObj();
    await getBeneficiaryList();
  }

  dynamic slotCheck() async {
    ApiCalls apiCalls = ApiCalls();
    List<int>? pincodeList = user.pinList;
    if(pincodeList == null){
      pincodeList = [];
    }
    List<dynamic> centers = await apiCalls.centers(pincodeList);
    if(user.wantFree == true){
      centers = filterFree(centers);
    }
    await Future.forEach(benList, (beneficiary) async{
      Beneficiary ben = getBen(beneficiary.toString());
      List<dynamic> validCenters = distribute(ben, centers);
      dynamic bookCenter = validCenters[0];
      int dose = getDose(ben);
      String sessionId = bookCenter['session_id'];
      List slots = bookCenter['slots'];
      String slot = slots[0];
      int centerId = bookCenter['center_id'];
      int? benId = ben.beneficiaryId;
      if(benId == null){
        benId = 0;
      }
      List<int> beneficiaries = [benId];
      Map<int, String> scheduleResponse = await apiCalls.schedule(dose, sessionId, slot, centerId, beneficiaries);
      scheduleResponse.forEach((key, value) {
        if(key == 200){
          // Refresh beneficiaries
          // Send notification
        }
        else if(key == 409){
          // Fully booked
        }
        else{
          // Something's wrong. Bad request or unauthenticated access or server error
        }
      });
    });
  }

  List<dynamic> distribute(Beneficiary benObj, List<dynamic> centers) {
    if(benObj.isEnabled == true && benObj.bookedSlot == false){
      if(benObj.isYoung == true){
        centers = filterYoung(centers);
      }
      else{
        return [];
      }
      // Filter vaccine
      centers = filterVaccine(centers, benObj.vaccine.toString());
      if(benObj.isDoseOneDone == false){
        return centers;
      }
      else if(benObj.isDoseOneDone == true && benObj.isDoseTwoDone == false){
        if(validDueDate(benObj.doseOneDate.toString(), benObj.vaccine.toString())){
          return centers;
        }
        else{
          return [];
        }
      }
      else{
        return [];
      }
    }
    else{
      return [];
    }
  }

  int getDose(Beneficiary beneficiary){
    if(beneficiary.isDoseOneDone == false){
      return 1;
    }
    else{
      return 2;
    }
  }

  List<dynamic> filterFree(List<dynamic> centers) {
    List newCenters = [];
    centers.forEach((ctr) {
      if(ctr['fee_type'] == 'Free'){
        newCenters.add(ctr);
      }
    });
    return newCenters;
  }

  List<dynamic> filterYoung(List<dynamic> centers) {
    List newCenters = [];
    centers.forEach((ctr) {
      if(ctr['min_age_limit'] == 18){
        newCenters.add(ctr);
      }
    });
    return newCenters;
  }

  List<dynamic> filterVaccine(List<dynamic> centers, String vaccine){
    List<dynamic> newCenters = [];
    if(vaccine == 'COVISHIELD'){
      centers.forEach((ctr) {
        if(ctr['vaccine'] == 'COVISHIELD'){
          newCenters.add(ctr);
        }
      });
      return newCenters;
    }
    else if(vaccine == 'COVAXIN'){
      centers.forEach((ctr) {
        if(ctr['vaccine'] == 'COVAXIN'){
          newCenters.add(ctr);
        }
      });
      return newCenters;
    }
    else{
      return centers;
    }

  }

  bool validDueDate(String dueDate, String vaccine){
    DateTime now = DateTime.now();
    List dmyList = vaccine.split('-');
    DateTime doseOneDate = DateTime.utc(dmyList[2], dmyList[1], dmyList[0]);
    if(vaccine == 'COVISHIELD'){
      return doseOneDate.isAfter(now.add(Duration(days: 84)));
    }
    else{
      // For COVAXIN
      return doseOneDate.isAfter(now.add(Duration(days: 21)));
    }
  }





  Future<void> getBeneficiaryList() async {
    benList = await getBenListFromPrefs();
  }

  Future<void> getUserObj() async {
    String userStr = await getUserFromPrefs();
    user = getUser(userStr);
  }


}