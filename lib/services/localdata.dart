import 'dart:convert';

class User{
  int phNo = 0;
  late int? districtId = 0;
  late bool? isSetup = false;

  User( {required this.phNo, this.districtId, this.isSetup} );

  // Set boolean to check if user has setup phone number
  User setSetup() {
    User user = User(phNo: phNo, isSetup: true);
    return user;
  }

  // Set district ID for the given phone number
  User setDId(int districtId) {
    User user = User(phNo: phNo, districtId: districtId, isSetup: true);
    return user;
  }

  // To save this to SharedPreferences
  String? saveData(User user) {
    String strData= '';
    Map<String, dynamic> mapUser = {};
    mapUser['phNo'] = user.phNo;
    mapUser['districtId'] = user.districtId;
    mapUser['isSetup'] = user.isSetup;
    strData = jsonEncode(mapUser);
    return strData;
  }

  // To decode data when we get from SharedPreferences into this object
  User getData(String strData){
    Map<String, dynamic> mapData = json.decode(strData);
    User user = User(phNo: int.parse(mapData['phNo']));
    // data.phNo = mapData['phNo'];
    try {
      user.phNo = int.parse(mapData['districtId']);
      user.isSetup = mapData['isSetup'] == 'true';
    }
    catch(e){
      return user;
    }
    return user;
  }

}

class Beneficiary{
  int beneficiaryId = 0;
  bool isDoseOneDone = false;
  bool wantFree = false;
  bool isOld = false;

  Beneficiary( {required this.beneficiaryId, required this.isDoseOneDone, required this.isOld, required this.wantFree} );

  // To save this to SharedPreferences
  String? saveBen(Beneficiary beneficiary){
    String strBen = '';
    Map<String,dynamic> mapBen = {};
    mapBen['beneficiaryId'] = beneficiary.beneficiaryId;
    mapBen['isDoseOneDone'] = beneficiary.isDoseOneDone;
    mapBen['wantFree'] = beneficiary.wantFree;
    mapBen['isOld'] = beneficiary.isOld;
    strBen = jsonEncode(mapBen);
    return strBen;
  }

  // To decode data when we get from SharedPreferences into this object
  Beneficiary getBen(String strBen){
    Map<String,dynamic> mapBen = json.decode(strBen);
    int beneficiaryId = int.parse(mapBen['beneficiaryId']);
    bool isDoseOneDone = mapBen['isDoseOneDone'] == 'true';
    bool wantFree = mapBen['wantFree'] == 'true';
    bool isOld = mapBen['isOld'] == 'true';
    Beneficiary beneficiary = Beneficiary(beneficiaryId: beneficiaryId, isDoseOneDone: isDoseOneDone, isOld: isOld, wantFree: wantFree);
    return beneficiary;
  }

}
