import 'dart:convert';

import 'package:flutter/material.dart';

import 'localdata.dart';
import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:vax_app/services/store_data.dart';
import 'package:vax_app/services/localdata.dart';
import 'package:vax_app/services/front_end_calls.dart';

class SlotCheck{

  late List<String> benList;
  late User user;
  late ApiCalls apiCalls;
  late List<int> pincodeList;

  FrontEndCalls frontEndCalls = FrontEndCalls();


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
    if(user.wantFree == true && user.wantPaid == false){
      centers = filterFree(centers);
    }
    else if (user.wantPaid == true && user.wantFree == false) {
      centers = filterPaid(centers);
    }
    List<String> status = [];
    int activeBens = 0;
    for (int i = 0; i < benList.length; i ++) {
      //status.add('booked');
      if (getBen(benList[i]).isEnabled == true) {
       activeBens ++;
      }
    }
    bool booked = false;
    int bookedBens = 0;
    //await Future.forEach(benList, (beneficiary) async{
    for (int i = 0; i < benList.length; i ++) {
      if (activeBens == bookedBens) {
        print("All done");
        break;
      }
      Beneficiary ben = getBen(benList[i].toString());
      if (ben.isEnabled == true) {
          //print(ben.beneficiaryName);
          List<dynamic> validCenters = [];
        //print("valid centers before distr: $validCenters");
        validCenters = distribute(ben, centers);
        //print(validCenters);
        if (validCenters.length != 0) {
          for (int j = 0; j < validCenters.length; j ++) {
            dynamic bookCenter = validCenters[j];
            print(bookCenter);
            String vaccine = bookCenter['vaccine'];
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
            print(bookCenter);
            Map<int, String> scheduleResponse = await apiCalls.schedule(
                dose, sessionId, slot, centerId, beneficiaries);
            for (var key in scheduleResponse.keys) {
              if (key == 200 && booked == false) {
                // Refresh beneficiaries
                status[i] = "done";
                booked = true;
                bookedBens ++;
                print(vaccine);
                ben.isEnabled = false;
                ben.bookedSlot = true;
                ben.vaccine = vaccine;
                print("in ben object: ${ben.vaccine}");
                ben.appointmentId = jsonDecode(scheduleResponse[key].toString())["appointment_confirmation_no"].toString();
                //print(ben.appointmentId);
                await setBenListToPrefs(benList);
                break;
                // Send notification
              }
              else if (key == 409 && booked == false) {
                // Fully booked
                status[i] = "fully booked";
              }
              else if (booked == false) {
                // Something's wrong. Bad request or unauthenticated access or server error
                status[i] = "error";
              }
            }
            if (booked == true) {
              booked = false;
              break;
            }
          }
        }
        else {
          status[i] = "no centers";
        }
      }
    }
    return status;
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  // This function checks each beneficiary's unique data and filters out the incoming list of centers
  // according to it's requirements
  List<dynamic> distribute(Beneficiary benObj, List<dynamic> centers) {
    print(benObj.isDoseOneDone);
    if(benObj.isEnabled == true && benObj.bookedSlot == false){
      print("statement 1");
      if(benObj.isYoung == true){
        print("young");
        centers = filterYoung(centers);
      }
      // Filter vaccine
      centers = filterVaccine(centers, benObj.vaccine.toString());
      //print(centers);
      if(benObj.isDoseOneDone == false){
        return centers;
      }
      else if(benObj.isDoseOneDone == true && benObj.isDoseTwoDone == false){
        //print("test");
        if(validDueDate(benObj.doseOneDate.toString(), benObj.vaccine.toString())){
          return validDoseTwo(centers);
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

  List<dynamic> filterPaid(List<dynamic> centers) {
    List newCenters = [];
    centers.forEach((ctr) {
      if(ctr['fee_type'] == 'Paid'){
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

  List<dynamic> validDoseTwo(List<dynamic> centers) {
    List<dynamic> newCenters = [];
    centers.forEach((center) {
      if (center['available_capacity_dose2'] > 9) {
        //print("filtered");
        newCenters.add(center);
      }
    });
    return newCenters;
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
      return doseOneDate.isAfter(now.add(Duration(days: 27)));
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
    slotCheck.apiCalls.listen();
    List<String> returnValue;
    while (starter == true) {
      print("searching");
      Future.delayed(Duration(seconds: 20));
      returnValue = await slotCheck.slotCheck();
      if (returnValue.contains('done')) {
        stopSearching();
        print("Booking done");
        return 'done';
      }
      else {
        continue;
      }
    }
  }
}