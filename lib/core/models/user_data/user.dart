import 'dart:convert';

import 'package:pokhara_app/core/models/user_data/user_position.dart';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/utilities.dart';

class User {
  int id;
  String mobileNumber;
  String androidVersion;
  String modelName;
  String mode;
  String otp;
  String mobileId;
  int status;
  String registrationDate;
  String referalCode;
  String name;
  String email;
  String gender;
  String profileImage;
  String address;
  int lastPositionId;
  UserPosition position;

  User(
      {this.id,
      this.mobileNumber,
      this.androidVersion,
      this.modelName,
      this.mode,
      this.otp,
      this.mobileId,
      this.status,
      this.registrationDate,
      this.referalCode,
      this.name,
      this.email,
      this.gender,
      this.profileImage,
      this.address,
      this.lastPositionId,
      this.position});

  String _getProfilePic(String val) {
    if (val != null) {
      if (val.contains('http')) {
        return val;
      } else if (val.isNotEmpty) {
        return Urls.photoUrl + val;
      }
    }
    return val;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNumber = json['mobile_number'];
    androidVersion = json['android_version'];
    modelName = json['model_name'];
    mode = json['mode'];
    otp = json['otp'];
    mobileId = json['mobile_id'];
    status = json['status'];
    registrationDate = json['registration_date'];
    referalCode = json['referal_code'];
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    profileImage = _getProfilePic(json['profile_image']);
    address = json['address'];
    lastPositionId =
        json['last_position_id'] == null || json['last_position_id'] == ''
            ? null
            : int.parse(json['last_position_id']
                .toString()); //check null if not null cast to int if string
    position = json['position'] != null
        ? new UserPosition.fromJson(json['position'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile_number'] = this.mobileNumber;
    data['android_version'] = this.androidVersion;
    data['model_name'] = this.modelName ?? '';
    data['mode'] = this.mode ?? '';
    data['otp'] = this.otp ?? '';
    data['mobile_id'] = this.mobileId ?? '';
    data['status'] = this.status ?? 0;
    data['registration_date'] = this.registrationDate ?? '';
    data['referal_code'] = this.referalCode ?? '';
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['profile_image'] = this.profileImage;
    data['address'] = this.address;
    data['last_position_id'] = this.lastPositionId ?? '';
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) data['name'] = this.name ?? '';
    if (this.email != null) data['email'] = this.email ?? '';
    if (this.gender != null) data['gender'] = this.gender ?? '';
    //if(data['profile_image'!=null ) data['profile_image'] = this.profileImage ?? '';
    if (this.address != null) data['address'] = this.address ?? '';
    data['mobile'] = this.mobileNumber;
    data['mobile_id'] = this.mobileId;

    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}

Future<dynamic> registerUser(User user) async {
  var body = {
    "mobile": user.mobileNumber,
    "mobile_id": user.mobileId,
    "model_name": user.modelName,
    "android_version": user.androidVersion,
    "referal_code": user.referalCode,
    "name": user.name,
    "address": user.address,
    "email": user.email,
  };
  final response = await http.post(Uri.parse(Urls.registerUrl), body: body);
  if (Utilities.handleStatus(response.statusCode)) {
    var body = json.decode(response.body);
    print(body);

    return body;
  }
  print(response.body);
  return false;
}

Future<String> getCallServerNumber() async {
  var header = {
    'Authorization': 'Bearer abcdefghij',
    'Accept': 'application/json'
  };
  try {
    var resp = await http.get(Uri.parse(Urls.getServerNum), headers: header);
    print(resp.body);
    if (resp.statusCode == 200) {
      var jbody = json.decode(resp.body);
      var num = jbody['data']['server_number'];
      return num;
    } else {
      return '';
    }
  } catch (e) {
    print('❌ Error getting server number');
    print(e.toString());
    return '';
  }
}

Future<bool> registerCallServer(String phNumber) async {
  final response = await http.get(
    Uri.parse(Urls.callServerUrl + phNumber),
  );
  if (Utilities.handleStatus(response.statusCode)) {
    return true;
  }
  return false;
}
