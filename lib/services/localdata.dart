import 'dart:convert';

class User{
  late int? phNo;
  late List<int>? pinList;
  late bool? isSetup;
  late bool? autoBook;

  User( {
    this.phNo = 0,
    this.isSetup = false,
    this.pinList,
    this.autoBook = true,
  } );

  // Set boolean to check if user has setup phone number
  void setSetup() {
    isSetup = true;
  }

  // Set district ID for the given phone number
  void setPinList(List<int> pList) {
    pinList = pList;
  }

  // Set the autoBook flag to false
  void disableAutoBook() {
    autoBook = false;
  }

  // Encode to string to save to SharedPreferences
  String saveUser() {
    Map<String, dynamic> mapUser = {};
    mapUser['phNo'] = phNo;
    mapUser['districtId'] = pinList;
    mapUser['isSetup'] = isSetup;
    mapUser['autoBook'] = autoBook;
    return jsonEncode(mapUser);
  }

  // Decode SharedPreferences String into this object
  void getUser(String strUser){
    Map<String, dynamic> mapUser = json.decode(strUser);
    phNo = int.parse(mapUser['phNo'].toString());
    try {
      isSetup = mapUser['isSetup'].toString() == 'true';
      autoBook = mapUser['autoBook'].toString() == 'true';
      pinList = mapUser['districtId'];
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
  late bool? wantFree;
  late bool? isOld;
  late bool? isDoseOneDone;
  late String? vaccine;
  late String? doseOneDate;

  Beneficiary( {
    this.beneficiaryId = 0,
    this.isDoseOneDone = false,
    this.isOld = false,
    this.wantFree = false,
    this.vaccine = 'any',
    this.doseOneDate,
    this.isEnabled = true,
  } );

  void setWantFree() {
    wantFree = true;
  }

  void setVaccine(String vac){
    vaccine = vac.toUpperCase();
  }

  void disableBen(){
    isEnabled = false;
  }

  // To save this to SharedPreferences
  String saveBen(){
    Map<String,dynamic> mapBen = {};
    mapBen['beneficiaryId'] = beneficiaryId;
    mapBen['isDoseOneDone'] = isDoseOneDone;
    mapBen['wantFree'] = wantFree;
    mapBen['isOld'] = isOld;
    mapBen['vaccine'] = vaccine;
    mapBen['doseOneDate'] = doseOneDate;
    mapBen['isEnabled'] = isEnabled;
    return jsonEncode(mapBen);
  }

  // To decode data when we get from SharedPreferences into this object
  void getBen(String strBen){
    Map<String,dynamic> mapBen = json.decode(strBen);
    beneficiaryId = int.parse(mapBen['beneficiaryId'].toString());
    isDoseOneDone = mapBen['isDoseOneDone'].toString() == 'true';
    wantFree = mapBen['wantFree'].toString() == 'true';
    isOld = mapBen['isOld'].toString() == 'true';
    vaccine = mapBen['vaccine'].toString();
    doseOneDate = mapBen['doseOneDate'].toString();
    isEnabled = mapBen['isEnabled'].toString() == 'true';
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
