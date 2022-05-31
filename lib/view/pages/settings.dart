import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/core/notifiers/providers/language_state.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:pokhara_app/view/widgets/lang_selector.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user;

  @override
  void initState() {
    var state = Provider.of<AuthState>(context, listen: false);
    user = state.credentials.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget logoutButton() {
      return Consumer<AuthState>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: FlatButton(
              minWidth: 30,
              textColor: Colors.white,
              onPressed: () {
                Utilities.showPlatformSpecificAlert(
                    title: UIStrings.logout,
                    body: UIStrings.confirmLogout,
                    context: context,
                    addionalAction: DialogAction(
                        label: UIStrings.logout,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                          value.signOut();
                        }));
              },
              color: Theme.of(context).primaryColor,
              child: Text(UIStrings.logout),
            ),
          );
        },
      );
    }

    return Consumer<LanguageState>(
      builder: (context, myType, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 97, 12, 90),
            title: Text(UIStrings.settings),
          ),
          body: ListView(
            children: [
              LanguageSelector(),
              logoutButton(),
              Divider(
                thickness: 4,
                indent: 8,
                endIndent: 8,
              ),
              infoWidget(),
              Divider(
                thickness: 4,
                indent: 8,
                endIndent: 8,
              ),
              shareWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget infoWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Assets.sbcbLogo,
            scale: 9,
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            'Sambriddha Multi-purpose Community Busines Pvt.Ltd',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 13,
          ),
          GestureDetector(
            onTap: () {
              launch('tel://061536271');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 13,
                ),
                Text(
                  '061-586272', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('tel://061536272');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 13,
                ),
                Text(
                  '061-586271', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('https://sbcb.com.np/');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.web),
                SizedBox(
                  width: 13,
                ),
                Text(
                  'sbcb.com.np', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('mailto:info@sbcb.com.np');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(
                  width: 13,
                ),
                Text(
                  'info@sbcb.com.np', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shareWidget() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Your Referral Code",
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    user.mobileNumber,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: user.mobileNumber))
                            .whenComplete(() => Utilities.showInToast(
                                "Copied to clipboard",
                                toastType: ToastType.SUCCESS));
                      },
                      icon: Icon(Icons.copy)),
                ],
              ),
            ],
          ),
          VerticalDivider(
            thickness: 3.0,
          ),
          Column(
            children: [
              Text(
                "Share App",
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Share.share(Constants.playstoreShareLink);
                    },
                    icon: Icon(
                      Icons.android,
                      color: Colors.green[700],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Share.share(Constants.appstoreShareLink);
                    },
                    icon: Icon(Icons.apple),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
