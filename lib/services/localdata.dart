import 'dart:convert';

class User{
  late int? phNo;
  late int? districtId;
  late bool? isSetup;

  User( {this.phNo = 0, this.isSetup = false, this.districtId} );

  // Set boolean to check if user has setup phone number
  void setSetup() {
    isSetup = true;
  }

  // Set district ID for the given phone number
  void setDId(int dID) {
    districtId = dID;
  }

  // To save this to SharedPreferences
  String saveUser() {
    Map<String, dynamic> mapUser = {};
    mapUser['phNo'] = phNo;
    mapUser['districtId'] = districtId;
    mapUser['isSetup'] = isSetup;
    return jsonEncode(mapUser);
  }

  // To decode data when we get from SharedPreferences into this object
  void getUser(String strUser){
    Map<String, dynamic> mapUser = json.decode(strUser);
    phNo = int.parse(mapUser['phNo'].toString());
    try {
      isSetup = mapUser['isSetup'].toString() == 'true';
      districtId = int.parse(mapUser['districtId'].toString());
    }
    catch(e){
      return;
    }
    return;
  }

}

class Beneficiary{
  late int? beneficiaryId;
  late bool? isDoseOneDone;
  late bool? wantFree;
  late bool? isOld;

  Beneficiary( {this.beneficiaryId = 0, this.isDoseOneDone = false, this.isOld = false, this.wantFree = false} );

  // To save this to SharedPreferences
  String saveBen(){
    Map<String,dynamic> mapBen = {};
    mapBen['beneficiaryId'] = beneficiaryId;
    mapBen['isDoseOneDone'] = isDoseOneDone;
    mapBen['wantFree'] = wantFree;
    mapBen['isOld'] = isOld;
    return jsonEncode(mapBen);
  }

  // To decode data when we get from SharedPreferences into this object
  void getBen(String strBen){
    Map<String,dynamic> mapBen = json.decode(strBen);
    beneficiaryId = int.parse(mapBen['beneficiaryId'].toString());
    isDoseOneDone = mapBen['isDoseOneDone'].toString() == 'true';
    wantFree = mapBen['wantFree'].toString() == 'true';
    isOld = mapBen['isOld'].toString() == 'true';
  }

}
