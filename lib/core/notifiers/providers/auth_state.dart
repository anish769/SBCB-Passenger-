import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pokhara_app/core/models/mobile_details.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/core/models/auth_data.dart';
import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/preferences.dart';
import 'package:pokhara_app/utils/utilities.dart';

class AuthState extends ChangeNotifier {
  AuthData _credentials;
  bool _isLoggedIn;

  AuthData get credentials => _credentials;
  bool get isAuthenticated => _isLoggedIn;

  AuthState() {
    _init();
  }

  _init() {
    _checkAuth();
  }

  _checkAuth() async {
    _isLoggedIn = false;
    var data = await Preference.getUser();
    if (data != null) {
      _credentials = AuthData.fromJson(json.decode(data));
      _isLoggedIn = true;
      Constants.token = _credentials.token;
    }

    notifyListeners();
  }

  // setUserData(User user) {
  //   _credentials.user = user;
  //   print(_credentials);
  //   Preference.storeUser(json.encode(_credentials.user.toJson()));

  //   notifyListeners();
  // }

  /// The [mobileID] is the Android or iOS version
  Future<dynamic> signIn(String phoneNum, String mobileID,
      {Function onTimeOUt}) async {
    var headers = {"Accept": "application/json"};
    var body = {
      "mobile": phoneNum,
      "mobile_id": mobileID, // version of android  or IOS
      "security_key": Constants.securityKey
    };

    try {
      final respose = await http
          .post(Uri.parse(Urls.loginUrl), headers: headers, body: body)
          .timeout(Duration(seconds: Constants.timeOutSec),
              onTimeout: onTimeOUt);
      if (Utilities.handleStatus(respose.statusCode)) {
        var obj = json.decode(respose.body);
        if (!obj['error']) {
          _isLoggedIn = true;

          _credentials = AuthData.fromJson(obj['data']);
          Preference.storeUser(json.encode(obj['data']));
          Constants.token = _credentials.token;
          print(_credentials.token);
          updateUser(_credentials.user);

          notifyListeners();
        } else {
          print(obj);
          return obj['message'];
        }
      } else {
        print(respose);
        return 'Unknown error';
      }
      notifyListeners();
      return _credentials;
    } catch (e) {
      print(e.toString());
      return "Some Error Occurred";
    }
  }

  Future<bool> updateUser(User user) async {
    var mobInfo = await MobileDetails.getDetails;
    user.androidVersion = mobInfo.osVersion;
    user.mobileId = mobInfo.mobileId;
    user.modelName = mobInfo.modelName;
    var body = user.toUpdateJson();
    var header = {
      'Authorization': 'Bearer ' + Constants.token,
      'Accept': 'application/json'
    };

    final response = await http.post(Uri.parse(Urls.registerUrl),
        headers: header, body: body);
    print(response.body);

    if (Utilities.handleStatus(response.statusCode)) {
      var data = json.decode(response.body);
      print(body);
      if (data['message'].contains('User device information updated')) {
        _credentials.user = User.fromJson(data['data']);
        Preference.storeUser(json.encode(_credentials.toJson()));

        notifyListeners();

        return true;
      }
    }
    return false;
  }

  Future<bool> updateUserPicture(String img) async {
    var body = {'image_base64': img.toString()};
    var header = {
      'Authorization': 'Bearer ' + Constants.token,
      'Accept': 'application/json'
    };

    final response = await http.post(Uri.parse(Urls.profileUpdate),
        headers: header, body: body);
    // print(response.body);

    if (Utilities.handleStatus(response.statusCode)) {
      var data = json.decode(response.body);
      //  print(body);
      if (data['message'].contains('Profile updated successfully')) {
        _credentials.user = User.fromJson(data['data']);
        Preference.storeUser(json.encode(_credentials.toJson()));

        notifyListeners();

        return true;
      }
    }
    return false;
  }

  Future signOut() async {
    Preference.clear();
    _isLoggedIn = false;
    _credentials = null;
    notifyListeners();
  }
}
