import 'package:flutter/foundation.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/preferences.dart';

class AppFlavour extends ChangeNotifier {
  AppFlavour() {
    _init();
  }
  _init() async {
    await Preference.setAppFlavour();
    notifyListeners();
  }

  void setFlavour(bool isProduction) async {
    Constants.isProduction = isProduction;
    await Preference.saveAppFlavour(isProduction);

    notifyListeners();
  }
}
