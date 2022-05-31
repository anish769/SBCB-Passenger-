import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:pokhara_app/utils/ui_strings.dart';

class Utilities {
  static Future<bool> isInternetWorking() async {
    bool condition1 = false;
    bool condition2 = false;

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        condition1 = true;
      }
    } on SocketException catch (_) {
      condition1 = false;
      // showInToast(MessagePrompts.NO_INTERNET);
    }

    //----------------------------------------------------------------------//

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        condition2 = true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        condition2 = true;
      } else
        condition2 = false;
    } on SocketException {
      //showInToast(MessagePrompts.NO_INTERNET);
      condition2 = false;
    }

    return condition1 & condition2;
  }

  static bool handleStatus(int statusCode) {
    bool res = false;
    switch (statusCode) {
      case HttpStatus.ok:
        res = true;
        break;

      case HttpStatus.internalServerError:
        // showInToast(MessagePrompts.SERVER_ERROR);
        break;

      case HttpStatus.connectionClosedWithoutResponse:
        //  showInToast("Connection closed.");
        break;

      case HttpStatus.tooManyRequests:
        //  showInToast("Too many requests.");
        break;

      case HttpStatus.requestTimeout:
        //  showInToast("Request time out.");
        break;

      default:
      // showInToast(MessagePrompts.TRY_AGAIN);
    }

    return res;
  }

  ///0 is top
  ///
  ///1 is centre
  ///
  ///2 is bottom and default
  static showInToast(String message, {ToastType toastType, int toastPos = 2}) {
    FlutterFlexibleToast.cancel();
    FlutterFlexibleToast.showToast(
        message: " " + message,
        toastLength: Toast.LENGTH_SHORT,
        toastGravity: toastPos == 2
            ? ToastGravity.BOTTOM
            : toastPos == 1
                ? ToastGravity.CENTER
                : ToastGravity.TOP,
        icon: toastType == null
            ? null
            : toastType == ToastType.ERROR
                ? ICON.ERROR
                : toastType == ToastType.INFO
                    ? ICON.INFO
                    : ICON.SUCCESS,
        radius: 12,
        elevation: 10,
        imageSize: 35,
        textColor: Colors.white,
        backgroundColor: toastType == null
            ? Colors.black
            : toastType == ToastType.ERROR
                ? Colors.red
                : toastType == ToastType.INFO
                    ? Colors.blue
                    : Colors.green,
        timeInSeconds: 2);
  }

  static Future<bool> mapExists(path) async {
    File map = File(path);

    return map.existsSync();
  }

  static deletMapIfExists(path) async {
    if (await mapExists(path)) {
      File map = File(path);
      await map.delete();
      return true;
    }
  }

  static showPlatformSpecificAlert(
      {@required String title,
      @required String body,
      @required BuildContext context,
      Function onDismiss,
      DialogAction addionalAction,
      Widget additional,
      bool canclose = true,
      bool dismissable}) {
    showDialog(
      barrierDismissible: dismissable == null ? false : dismissable,
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  textAlign: TextAlign.left,
                ),
                content: Text(body),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: additional != null
                        ? additional
                        : canclose
                            ? Text(UIStrings.close)
                            : null,
                    onPressed: () {
                      if (onDismiss != null) {
                        onDismiss();
                      }
                      if (canclose) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  if (addionalAction != null)
                    CupertinoDialogAction(
                      child: Text(addionalAction.label),
                      onPressed: addionalAction.onPressed,
                    )
                ],
              )
            : AlertDialog(
                title: new Text(
                  title,
                  textAlign: TextAlign.left,
                ),
                content: Text(body),
                actions: <Widget>[
                  FlatButton(
                    child: additional != null
                        ? additional
                        : canclose
                            ? Text(UIStrings.close)
                            : null,
                    onPressed: () {
                      if (onDismiss != null) {
                        onDismiss();
                      }
                      if (canclose) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  if (addionalAction != null)
                    FlatButton(
                      child: Text(addionalAction.label),
                      onPressed: addionalAction.onPressed,
                    ),
                ],
              );
      },
    );
  }
}

class DialogAction {
  final Function onPressed;
  final String label;

  DialogAction({@required this.label, @required this.onPressed});
}

enum ToastType { INFO, ERROR, SUCCESS }
