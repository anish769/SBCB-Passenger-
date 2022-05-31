import 'package:pokhara_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static const _authData = 'authdata';
  static const _lang = 'lang';
  static const _privateCredentials = 'private_credentials';
  static const _regNumber = 'reg_number';
  static const _appFlavour = 'app_flavour';

  static storeUser(String data) async {
    try {
      var pref = await SharedPreferences.getInstance();
      pref.setString(_authData, data);
    } catch (e) {
      print("failed to store user");
      print(e);
    }
  }

  static Future<String> getUser() async {
    try {
      var pref = await SharedPreferences.getInstance();
      return pref.getString(_authData);
    } catch (e) {
      print("failed to get user");
      print(e);
      return null;
    }
  }

  static getRegisteredNumber() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(_regNumber);
  }

  static saveRegisteredNumber(String number) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(_regNumber, number);
  }

  static saveAppLanguage(Lang lang) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(_lang, lang.toString());
  }

  static Future<Lang> getAppLanguage() async {
    var pref = await SharedPreferences.getInstance();
    var res = pref.getString(_lang);
    if (res == null) return null;
    return res == Lang.ENG.toString() ? Lang.ENG : Lang.NP;
  }

  static savePrivateCredential(String uname, String pw) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(_privateCredentials, "$uname,$pw");
  }

  static clearPrivateCredential() async {
    var pref = await SharedPreferences.getInstance();
    return pref.remove(_privateCredentials);
  }

  static Future<String> getPrivateCredential() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(_privateCredentials);
  }

  static saveAppFlavour(bool val) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setBool(_appFlavour, val);
  }
  //default is production which is true;

  static Future<Null> setAppFlavour() async {
    var pref = await SharedPreferences.getInstance();
    Constants.isProduction = pref.getBool(_appFlavour) ?? true;
    print("production: " + Constants.isProduction.toString());
  }

  static clear() async {
    var pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
