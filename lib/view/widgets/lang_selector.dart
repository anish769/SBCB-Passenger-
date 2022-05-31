// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pokhara_app/core/notifiers/providers/language_state.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var langProvider = Provider.of<LanguageState>(context, listen: false);
    langChooser() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(UIStrings.language,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                  borderSide: BorderSide(
                      width: Constants.currentLang == Lang.NP ? 3 : 0),
                  child: Text(
                    "🇳🇵",
                    style: TextStyle(fontSize: 32),
                  ),
                  onPressed: () {
                    if (Constants.currentLang != Lang.NP) {
                      langProvider.setLang(Lang.NP);
                    }
                  }),
              OutlineButton(
                  borderSide: BorderSide(
                      width: Constants.currentLang == Lang.ENG ? 3 : 0),
                  child: Text(
                    "🇬🇧",
                    style: TextStyle(fontSize: 32),
                  ),
                  onPressed: () {
                    if (Constants.currentLang != Lang.ENG) {
                      langProvider.setLang(Lang.ENG);

                      //     AppPreference().setPreferredLanguage(Constants.currentLang);

                      //     Utilities.showInToast(MessagePrompts.LANGUAGE_SWITCHED);
                    }
                  }),
            ],
          ),
        ],
      );
    }

    return langChooser();
  }
}
