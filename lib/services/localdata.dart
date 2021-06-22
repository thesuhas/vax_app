import 'dart:convert';

import 'dart:math';

class User{
  late int? phNo;
  late List<int>? pinList;
  late bool? isSetup;
  late bool? wantFree;
  late bool? wantPaid;

  User( {
    this.phNo = 0,
    this.isSetup = false,
    this.wantFree = true,
    this.pinList,
    this.wantPaid = true,
  } );

  // Set boolean to true after he is done setting up
  void setSetup() {
    isSetup = true;
  }

  // Set pincode list for the given phone number
  void setPinList(List<int> pList) {
    pinList = pList;
  }


  // Encode to string to save to SharedPreferences
  String saveUser() {
    Map<String, dynamic> mapUser = {};
    mapUser['phNo'] = phNo;
    mapUser['pinList'] = pinList;
    mapUser['isSetup'] = isSetup;
    mapUser['wantFree'] = wantFree;
    mapUser['wantPaid'] = wantPaid;
    return jsonEncode(mapUser);
  }

  // Decode SharedPreferences String into this object
  void getUser(String strUser){
    Map<String, dynamic> mapUser = json.decode(strUser);
    phNo = int.parse(mapUser['phNo'].toString());
    try {
      isSetup = mapUser['isSetup'].toString() == 'true';
      List<int> pins = [];
      //pinList = [];
      for (int i = 0; i < mapUser['pinList'].length; i ++) {
        pins.add(mapUser['pinList'][i]);
      }
      pinList = pins;
      wantFree = mapUser['wantFree'].toString() == 'true';
      wantPaid = mapUser['wantPaid'].toString() == 'true';
    }
    catch(e){
      return;
    }
    return;
  }

}

class Beneficiary{
  late String? beneficiaryName;
  late String? vaccinationStatus;
  late int? beneficiaryId;
  late bool? isEnabled;
  late bool? isYoung;
  late bool? isDoseOneDone;
  late String? vaccine;
  late String? doseOneDate;
  late bool? isDoseTwoDone;
  late bool? bookedSlot;
  late String? appointmentId;

  Beneficiary( {
    this.beneficiaryName = 'John Doe',
    this.vaccinationStatus,
    this.beneficiaryId = 0,
    this.isDoseOneDone = false,
    this.isDoseTwoDone = false,
    this.isYoung = false,
    this.vaccine = 'ANY',
    this.doseOneDate,
    this.isEnabled = false,
    this.bookedSlot = false,
    this.appointmentId = '',
  } );


  void toggle(){
    if(isEnabled == true){
      isEnabled = false;
    }
    else{
      isEnabled = true;
    }
  }

  // To save this to SharedPreferences
  String saveBen(){
    Map<String,dynamic> mapBen = {};
    mapBen['beneficiaryName'] = beneficiaryName;
    mapBen['vaccinationStatus'] = vaccinationStatus;
    mapBen['beneficiaryId'] = beneficiaryId;
    mapBen['isDoseOneDone'] = isDoseOneDone;
    mapBen['isYoung'] = isYoung;
    mapBen['vaccine'] = vaccine;
    mapBen['doseOneDate'] = doseOneDate;
    mapBen['isEnabled'] = isEnabled;
    mapBen['isDoseTwoDone'] = isDoseTwoDone;
    mapBen['bookedSlot'] = bookedSlot;
    mapBen['appointmentId'] = appointmentId;
    return jsonEncode(mapBen);
  }

  // To decode data when we get from SharedPreferences into this object
  void getBen(String strBen){
    Map<String,dynamic> mapBen = json.decode(strBen);
    beneficiaryName = mapBen['beneficiaryName'].toString();
    vaccinationStatus = mapBen['vaccinationStatus'].toString();
    beneficiaryId = int.parse(mapBen['beneficiaryId'].toString());
    isDoseOneDone = mapBen['isDoseOneDone'].toString() == 'true';
    isYoung = mapBen['isYoung'].toString() == 'true';
    vaccine = mapBen['vaccine'].toString();
    doseOneDate = mapBen['doseOneDate'].toString();
    isEnabled = mapBen['isEnabled'].toString() == 'true';
    isDoseTwoDone = mapBen['isDoseTwoDone'].toString() == 'true';
    bookedSlot = mapBen['bookedSlot'].toString() == 'true';
    appointmentId = mapBen['appointmentId'].toString();
  }

}

User getUser(String strUser){
  User user = User();
  user.getUser(strUser);
  return user;
}

Beneficiary getBen(String strBen){
  Beneficiary beneficiary = Beneficiary();
  beneficiary.getBen(strBen);
  return beneficiary;
}
