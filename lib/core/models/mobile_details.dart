import 'dart:io';

import 'package:device_info/device_info.dart';

class MobileDetails {
  final String mobileId;
  final String osVersion;
  final String modelName;

  MobileDetails({this.mobileId, this.osVersion, this.modelName});

  static Future<MobileDetails> get getDetails async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return MobileDetails(
          mobileId: androidInfo.androidId,
          modelName: androidInfo.model,
          osVersion: "Android " + androidInfo.version.release.toString());
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return MobileDetails(
          mobileId: iosInfo.identifierForVendor,
          modelName: iosInfo.name,
          osVersion: "iOS " + iosInfo.systemVersion.toString());
    }
  }
}
