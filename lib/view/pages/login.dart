import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokhara_app/core/models/auth_data.dart';
import 'package:pokhara_app/core/models/mobile_details.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/core/notifiers/providers/app_flavour.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:pokhara_app/view/pages/register.dart';
import 'package:pokhara_app/view/widgets/lang_selector.dart';
import 'package:pokhara_app/view/widgets/terms_condition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _numberController = new TextEditingController();
  //..text = '9801017810'; //9810371273 //9801017810
  String _callServerNum = '';

  bool _termsChecked = false;
  bool generalLoading = false;
  bool triedFetchingServerNumber = false;
  int _counter = 0;

  String registerMessage = "";

  @override
  void initState() {
    _initFunc();
    super.initState();
  }

  _initFunc() async {
    int count = 0;
    do {
      var value = await getCallServerNumber();
      print('call server: ' + value);
      if (value.isNotEmpty) {
        setState(() {
          _callServerNum = value;
          triedFetchingServerNumber = true;
        });
        break;
      } else {
        count++;
      }
    } while (count < 3);
    if (count == 3 && _callServerNum.isEmpty) {
      setState(() {
        triedFetchingServerNumber = true;
      });
      Utilities.showInToast(
          "Coundn't fetch call server number. Please try again",
          toastType: ToastType.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool valildateInput(String phNum) {
      if (phNum.length == 10) {
        return true;
      } else {
        Utilities.showInToast(UIStrings.tenDigit, toastType: ToastType.ERROR);
        return false;
      }
    }

    closeDialog() {
      if (!generalLoading) return;
      setState(() {
        generalLoading = false;
        Navigator.pop(context);
      });
    }

    directLogin(String number) async {
      var state = Provider.of<AuthState>(context, listen: false);
      var details = await MobileDetails.getDetails;
      var resp = await state.signIn(number.trim(), details.mobileId);
      closeDialog();

      if (resp is AuthData && resp != null) {
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      }
    }

    checkForAPIResponse(bool isFirst) async {
      //waiting for 15 secs - call dial and hangup
      var res = false;
      await registerCallServer(_numberController.text).then((value) async {
        print(value);
        res = value;

        if (value) {
          directLogin(_numberController.text);
        } else {
          if (!isFirst) {
            Utilities.showInToast(
                'Session expired, Please call the server number',
                toastType: ToastType.ERROR);
            closeDialog();
          }
        }
      });
      return res;
    }

    Future generalLoadingDialog(BuildContext context) async {
      setState(() {
        generalLoading = true;
      });
      return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logging in. Please wait."),
            content: Container(
              child: Center(child: CircularProgressIndicator()),
              height: 35.0,
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            triedFetchingServerNumber
                ? FloatingActionButton(
                    heroTag: "refetch",
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: _initFunc,
                    child: Icon(
                      Icons.refresh,
                      size: 38,
                    ),
                  )
                : SizedBox(),
            FloatingActionButton(
              heroTag: "call",
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (!_termsChecked) {
                  Utilities.showInToast(UIStrings.agreeTerms,
                      toastType: ToastType.INFO);
                  return;
                }
                bool connected = await Utilities.isInternetWorking();
                if (connected) {
                  //validation
                  if (valildateInput(_numberController.text)) {
                    generalLoadingDialog(context);
                    // if (_numberController.text == "9823036454" ||
                    //     _numberController.text == "9813153789") {
                    directLogin(_numberController.text);
                    // } else {
                    //   Utilities.showInToast('Please call the given number',
                    //       toastType: ToastType.INFO, toastPos: 0);
                    //   //   launch(
                    //       "tel:${_callServerNum.isEmpty ? Constants.callServerNum : _callServerNum}");

                    // if (!await checkForAPIResponse(true)) {
                    //   await Future.delayed(Duration(seconds: 10));

                    //   checkForAPIResponse(false);
                    // }
                  }
                } else {
                  Utilities.showInToast(UIStrings.noNetwork,
                      toastType: ToastType.INFO);
                }
              },
              child: Icon(
                Icons.call,
                size: 38,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_counter < 10) {
                        _counter++;
                      } else {
                        Provider.of<AppFlavour>(context, listen: false)
                            .setFlavour(!Constants.isProduction);

                        Utilities.showInToast(
                            (Constants.isProduction ? "Production" : "Test") +
                                '\n' +
                                Urls.endPoint,
                            toastType: ToastType.INFO);
                        _counter = 0;
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          Assets.appLogo,
                          scale: 2,
                          height: 300,
                          width: 300,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    UIStrings.loginMessage,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.amber[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                numberField(),
                termsWidget(),
                GestureDetector(
                  onTap: () async {
                    User user = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RegisterPage()));
                    if (user != null) {
                      // directLogin(user.mobileNumber);
                      setState(() {
                        registerMessage = UIStrings.registerMessage;
                      });
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 58.0),
                  child: LanguageSelector(),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row termsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
            value: _termsChecked,
            onChanged: (val) {
              setState(() {
                _termsChecked = val;
              });
            }),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => TermsConditions()));
          },
          child: Text(
            UIStrings.iAgree,
            style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  Widget numberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Container(
          child: TextField(
        style: TextStyle(letterSpacing: 2.5, fontSize: 18),
        controller: _numberController,
        maxLength: 10,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          hintText: UIStrings.phone,
          prefixText: '+977 - ',
          icon: Icon(Icons.phone),
        ),
      )),
    );
  }
}
