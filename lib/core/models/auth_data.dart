import 'package:pokhara_app/core/models/user_data/user.dart';

class AuthData {
  String token;
  User user;
  String appVersion;
  String serverTime;

  AuthData({this.token, this.user, this.appVersion, this.serverTime});

  AuthData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user =
        json['userData'] != null ? new User.fromJson(json['userData']) : null;
    appVersion = json['appVersion'];
    serverTime = json['serverTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['userData'] = this.user.toJson();
    }
    data['appVersion'] = this.appVersion;
    data['serverTime'] = this.serverTime;
    return data;
  }
}
