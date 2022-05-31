import 'package:flutter/foundation.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/preferences.dart';

class LanguageState extends ChangeNotifier {
  LanguageState() {
    _init();
  }
  _init() async {
    await Preference.getAppLanguage();

    notifyListeners();
  }

  void setLang(Lang lang) async {
    Constants.currentLang = lang;
    await Preference.saveAppLanguage(lang);

    notifyListeners();
  }
}
