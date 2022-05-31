import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';

class ShareView extends StatefulWidget {
  @override
  _ShareViewState createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  int _minTimeHours = 1;
  int _maxTimeHours = 5;
  int _timeHours = 1;
  int _maxContacts = 3;
  List<PhoneContact> _contacts = [];
  @override
  Widget build(BuildContext context) {
    Widget timeSelector() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (_timeHours > _minTimeHours) {
                  setState(() {
                    --_timeHours;
                  });
                }
              }),
          Text("$_timeHours hour(s)"),
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                if (_timeHours < _maxTimeHours)
                  setState(() {
                    _timeHours++;
                  });
              }),
        ],
      );
    }

    Widget contactPicker() {
      return FlatButton.icon(
        icon: Icon(Icons.people, color: Colors.white),
        label: Text('Choose Contact ' + _contacts.length.toString() + '/3'),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () async {
          if (_contacts.length < _maxContacts) {
            FlutterContactPicker.hasPermission().then((hasPermission) async {
              if (hasPermission) {
                final contact = await FlutterContactPicker.pickPhoneContact();
                print(contact);
                setState(() {
                  _contacts.add(contact);
                });
              } else {
                FlutterContactPicker.requestPermission(force: true);
              }
            });
          } else {
            Utilities.showInToast(
                'You have already selected $_maxContacts contacts',
                toastType: ToastType.INFO);
          }
        },
      );
    }

    Widget share() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton.icon(
            icon: Icon(Icons.check_circle, color: Colors.white),
            label: Text('Share'),
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              if (_contacts.isNotEmpty) {
                var numJson = _contacts.map<Map<String, dynamic>>((e) {
                  var num = e.phoneNumber.number;

                  //removing unwanted chars liKe: space, -, ( and )
                  num = num.replaceAll(RegExp(r' |-|\(|\)'), '');
                  return {'mobile': num};
                }).toList();
                print(numJson);
                var data = {
                  'contacts': numJson.toString(),
                  'expiry_time': _timeHours.toString()
                };
                print(data);
                Navigator.pop(context, data);
              } else {
                Utilities.showInToast('Please select at least 1 contact!',
                    toastType: ToastType.INFO);
              }
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.close, color: Colors.white),
            label: Text('Cancel'),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
          )
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              UIStrings.shareLocation,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Choose duration',
            textAlign: TextAlign.left,
          ),
          timeSelector(),
          contactPicker(),
          share()
        ],
      ),
    );
  }
}
