import 'dart:convert';

class User{
  late int? phNo;
  late List<int>? pinList;
  late bool? isSetup;
  late bool? wantFree;

  User( {
    this.phNo = 0,
    this.isSetup = false,
    this.pinList,
    this.wantFree = false,
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
    return jsonEncode(mapUser);
  }

  // Decode SharedPreferences String into this object
  void getUser(String strUser){
    Map<String, dynamic> mapUser = json.decode(strUser);
    phNo = int.parse(mapUser['phNo'].toString());
    try {
      isSetup = mapUser['isSetup'].toString() == 'true';
      pinList = mapUser['pinList'];
      wantFree = mapUser['wantFree'];
    }
    catch(e){
      return;
    }
    return;
  }

}

class Beneficiary{
  late int? beneficiaryId;
  late bool? isEnabled;
  late bool? isYoung;
  late bool? isDoseOneDone;
  late String? vaccine;
  late String? doseOneDate;
  late bool? isDoseTwoDone;
  late bool? bookedSlot;

  Beneficiary( {
    this.beneficiaryId = 0,
    this.isDoseOneDone = false,
    this.isDoseTwoDone = false,
    this.isYoung = true,
    this.vaccine = 'ANY',
    this.doseOneDate,
    this.isEnabled = true,
    this.bookedSlot = false,
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
    mapBen['beneficiaryId'] = beneficiaryId;
    mapBen['isDoseOneDone'] = isDoseOneDone;
    mapBen['isYoung'] = isYoung;
    mapBen['vaccine'] = vaccine;
    mapBen['doseOneDate'] = doseOneDate;
    mapBen['isEnabled'] = isEnabled;
    mapBen['isDoseTwoDone'] = isDoseTwoDone;
    mapBen['bookedSlot'] = bookedSlot;
    return jsonEncode(mapBen);
  }

  // To decode data when we get from SharedPreferences into this object
  void getBen(String strBen){
    Map<String,dynamic> mapBen = json.decode(strBen);
    beneficiaryId = int.parse(mapBen['beneficiaryId'].toString());
    isDoseOneDone = mapBen['isDoseOneDone'].toString() == 'true';
    isYoung = mapBen['isYoung'].toString() == 'true';
    vaccine = mapBen['vaccine'].toString();
    doseOneDate = mapBen['doseOneDate'].toString();
    isEnabled = mapBen['isEnabled'].toString() == 'true';
    isDoseTwoDone = mapBen['isDoseTwoDone'].toString() == 'true';
    bookedSlot = mapBen['bookedSlot'].toString() == 'true';
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
