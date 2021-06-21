import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vax_app/services/cowin_api_calls.dart';
import 'package:vax_app/services/localdata.dart';

class StoreData{


  Future<void> getAndSaveData() async {

    // This function refreshes the beneficiary data stored in local storage
    // It should be called in one of these three scenarios
    // 1. First time user setup
    // 2. When a slot becomes available, refresh the data and then proceed to book so that there would be no errors
    // 3. When user clicks "Refresh Beneficiary List" or something equivalent

    ApiCalls apiCalls = ApiCalls();
    await apiCalls.setToken();
    await apiCalls.getBen();
    List<dynamic>? benList = apiCalls.benList;
    if(benList == null){
      benList = [];
    }
    benList.forEach((element) {
      saveData(element);
    });
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  Future<void> saveData(dynamic eachBen) async {
    // Set Beneficiary Object
    Beneficiary beneficiary = Beneficiary();
    beneficiary.beneficiaryName = eachBen['name'];
    beneficiary.vaccinationStatus = eachBen['vaccination_status'];
    beneficiary.beneficiaryId = int.parse(eachBen['beneficiary_reference_id']);
    if(2021 - int.parse(eachBen['birth_year']) < 44){
      beneficiary.isYoung = true;
    }
    String vaccinationStatus = eachBen['vaccination_status'];
    if(vaccinationStatus == 'Not Vaccinated'){
      List<dynamic> appointments = eachBen['appointments'];
      if(appointments.length == 1){
        beneficiary.bookedSlot = true;
      }
    }
    else if(vaccinationStatus == 'Partially Vaccinated'){
      beneficiary.isDoseOneDone = true;
      beneficiary.vaccine = eachBen['vaccine'].toString().toUpperCase();
      beneficiary.doseOneDate = eachBen['dose1_date'].toString();
      List<dynamic> appointments = eachBen['appointments'];
      if(appointments.length == 2){
        beneficiary.bookedSlot = true;
      }
    }
    else if(vaccinationStatus == 'Vaccinated'){
      beneficiary.isDoseOneDone = true;
      beneficiary.isDoseTwoDone = true;
    }


    // Get Beneficiary List from storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? benList = prefs.getStringList('benList');
    if(benList == null){
      benList = [];
    }

    // Function to check if a particular beneficiary is already in the list. If so, remove it
    benList = removeIfExists(benList, beneficiary);

    // Saving the beneficiary back to the storage
    String benStr = beneficiary.saveBen();
    benList.add(benStr);
    prefs.setStringList('benList', benList);
    print("EVERYTHING WORKED NAKKAN");
  }

  // Supporting function. NOT TO BE CALLED SEPARATELY!
  List<String> removeIfExists(List<String> benList, Beneficiary beneficiary){
    benList.forEach((element) {
      Beneficiary checkBeneficiary = getBen(element);
      if(beneficiary.beneficiaryId == checkBeneficiary.beneficiaryId){
        benList.remove(element);
      }
    });
    return benList;
  }

}


// Made these in case we need to set or get data to and from the local storage
Future<List<String>> getBenListFromPrefs() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String>? benList = pref.getStringList('benList');
  if(benList == null){
    benList = [];
  }
  return benList;
}

Future<String> getUserFromPrefs() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('user').toString();

}

Future<void> setBenListToPrefs(List<String> benList) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList('benList', benList);
}

Future<void> setUserToPrefs(String user) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('user', user);
}
