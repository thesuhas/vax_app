import 'localdata.dart';
import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:vax_app/services/store_data.dart';
import 'package:vax_app/services/localdata.dart';

class SlotCheck{

  late List<String> benList;
  late User user;
  late ApiCalls apiCalls;
  late List<int> pincodeList;


  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Sets this object with the beneficiary list from local storage
  Future<void> setBeneficiaryList() async {
    benList = await getBenListFromPrefs();
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Sets this object with the user details from local storage
  Future<void> setUserObj() async {
    String userStr = await getUserFromPrefs();
    user = getUser(userStr);
    //print(user.pinList);
  }

  // This function must be called once after which the slotCheck function can be called
  Future<void> initialise() async {
    await setUserObj();
    await setBeneficiaryList();
    apiCalls = ApiCalls();
    List<int>? pList = user.pinList;
    //print("plist: $pList");
    if(pList == null){
      pList = [];
    }
    pincodeList = pList;
  }

  // This is the function that must run in the background
  dynamic slotCheck() async {
    List<dynamic> centers = await apiCalls.centers(pincodeList);
    if(user.wantFree == true){
      centers = filterFree(centers);
    }
    String? status;
    bool booked = false;
    await Future.forEach(benList, (beneficiary) async{
      Beneficiary ben = getBen(beneficiary.toString());
      //print(ben.beneficiaryName);
      List<dynamic> validCenters = [];
      //print("valid centers before distr: $validCenters");
      validCenters = distribute(ben, centers);
      //print(validCenters);
      if (validCenters.length != 0) {
        dynamic bookCenter = validCenters[0];
        int dose = getDose(ben);
        String sessionId = bookCenter['session_id'].toString();
        List slots = bookCenter['slots'];
        String slot = slots[0].toString();
        int centerId = int.parse(bookCenter['center_id'].toString());
        int? benId = ben.beneficiaryId;
        if (benId == null) {
          benId = 0;
        }
        List<int> beneficiaries = [benId];
        Map<int, String> scheduleResponse = await apiCalls.schedule(
            dose, sessionId, slot, centerId, beneficiaries);
        scheduleResponse.forEach((key, value) {
          if (key == 200 && booked == false) {
            // Refresh beneficiaries
            status = "done";
            booked = true;
            // Send notification
          }
          else if (key == 409 && booked == false) {
            // Fully booked
            status = "fully booked";
          }
          else if (booked == false) {
            // Something's wrong. Bad request or unauthenticated access or server error
            status = "error";
          }
        });
      }
      else {
        status = "no centers";
      }
    });
    return status;
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // This function checks each beneficiary's unique data and filters out the incoming list of centers
  // according to it's requirements
  List<dynamic> distribute(Beneficiary benObj, List<dynamic> centers) {
    if(benObj.isEnabled == true && benObj.bookedSlot == false){
      print("statement 1");
      if(benObj.isYoung == true){
        print("young");
        centers = filterYoung(centers);
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

      }

    }
    return centers;
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Returns the dose number of a particular beneficiary
  int getDose(Beneficiary beneficiary){
    if(beneficiary.isDoseOneDone == false){
      return 1;
    }
    else{
      return 2;
    }
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Returns centers which provide vaccine for free
  List<dynamic> filterFree(List<dynamic> centers) {
    List newCenters = [];
    centers.forEach((ctr) {
      if(ctr['fee_type'] == 'Free'){
        newCenters.add(ctr);
      }
    });
    return newCenters;
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Returns centers which provide vaccine for ages 18 and above
  List<dynamic> filterYoung(List<dynamic> centers) {
    List newCenters = [];
    centers.forEach((ctr) {
      if(ctr['min_age_limit'] == 18){
        newCenters.add(ctr);
      }
    });
    return newCenters;
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Returns centers which provide a particular vaccine only
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

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // Checks if a dose one vaccinated beneficiary is eligible for dose two
  bool validDueDate(String dueDate, String vaccine){
    DateTime now = DateTime.now();
    List dmyList = dueDate.split('-');
    //print(dmyList);
    DateTime doseOneDate = DateTime.utc(int.parse(dmyList[2]), int.parse(dmyList[1]), int.parse(dmyList[0]));
    if(vaccine == 'COVISHIELD'){
      return doseOneDate.isAfter(now.add(Duration(days: 83)));
    }
    else{
      // For COVAXIN
      return doseOneDate.isAfter(now.add(Duration(days: 20)));
    }
  }


}

class StarterObject {

  bool starter = true;

  void stopSearching() {
    starter = false;
  }

  dynamic startSearching() async {
    SlotCheck slotCheck = SlotCheck();
    await slotCheck.initialise();
    String returnValue;
    while (starter == true) {
      print("searching");
      Future.delayed(Duration(seconds: 20));
      returnValue = await slotCheck.slotCheck();
      if (returnValue == 'done') {
        stopSearching();
        return 'done';
      }
      else {
        continue;
      }
    }
  }
}