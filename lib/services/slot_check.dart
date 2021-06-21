import 'localdata.dart';
import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:vax_app/services/store_data.dart';

class SlotCheck{

  List<String> benList;
  User user;
  late ApiCalls apiCalls;
  late List<int> pincodeList;

  SlotCheck( {
    required this.benList,
    required this.user,
} );

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
  }

  // This function must be called once after which the slotCheck function can be called
  Future<void> initialise() async {
    await setUserObj();
    await setBeneficiaryList();
    apiCalls = ApiCalls();
    List<int>? pList = user.pinList;
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

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // This function checks each beneficiary's unique data and filters out the incoming list of centers
  // according to it's requirements
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
    List dmyList = vaccine.split('-');
    DateTime doseOneDate = DateTime.utc(dmyList[2], dmyList[1], dmyList[0]);
    if(vaccine == 'COVISHIELD'){
      return doseOneDate.isAfter(now.add(Duration(days: 83)));
    }
    else{
      // For COVAXIN
      return doseOneDate.isAfter(now.add(Duration(days: 20)));
    }
  }


}