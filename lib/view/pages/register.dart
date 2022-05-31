import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:pokhara_app/core/models/mobile_details.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isComplete = false;
  bool isNameComplete = false;
  bool callListnerLoading = false;
  bool generalLoading = false;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController referalCodeController =
      new TextEditingController(text: "9857641950");
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Future generalLoadingDialog(BuildContext context) async {
      setState(() {
        generalLoading = true;
      });
      return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Loading"),
            content: Container(
              child: Center(child: CircularProgressIndicator()),
              height: 35.0,
            ),
          );
        },
      );
    }

    bool validate() {
      return nameController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;
    }

    registerNewUser() async {
      var mobInfo = await MobileDetails.getDetails;

      var user = User(
        androidVersion: mobInfo.osVersion,
        mobileNumber: phoneController.text,
        mobileId: mobInfo.mobileId,
        modelName: mobInfo.modelName,
        referalCode: referalCodeController.text,
        name: nameController.text,
        email: emailController.text,
        address: addressController.text,
      );

      registerUser(user).then((value) async {
        if (value is bool) {
          Utilities.showInToast('Registration Failed',
              toastType: ToastType.ERROR);
        } else {
          if (!value['error']) {
            Utilities.showInToast(value['message'],
                toastType: ToastType.SUCCESS);
            // var state = Provider.of<AuthState>(context, listen: false);
            // state.setUserData(state.credentials, user);
            Navigator.pop(context);
            Navigator.pop(context, user);
          } else {
            Utilities.showInToast(value['message'], toastType: ToastType.ERROR);

            Navigator.of(context).pop();
            Navigator.pop(context, user);
          }
        }
      });
    }

    Widget numberField() {
      return TextField(
        autofocus: true,
        cursorWidth: 4,
        cursorColor: Colors.black,
        onChanged: (text) {},
        controller: phoneController,
        maxLength: 10,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          labelText: '9801000000',
          labelStyle: TextStyle(color: Color.fromARGB(255, 162, 156, 162)),
          prefixText: '+977 ',
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 162, 156, 162), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black, //this has no effect
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }

    Widget referrelCodeField() {
      return ExpansionTile(
        title: Text("Referal Code"),
        children: [
          TextField(
            cursorColor: Colors.black,
            onChanged: (text) {},
            controller: referalCodeController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.call,
                color: Colors.grey,
              ),
              labelText: 'Referal Code (Optional)',
              labelStyle: TextStyle(color: Color.fromARGB(255, 162, 156, 162)),
              suffixIcon: IconButton(
                onPressed: () => referalCodeController.clear(),
                icon: Icon(
                  Icons.clear,
                  size: 16,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 162, 156, 162), width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black, //this has no effect
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      );
    }

    Widget emailField() {
      return TextField(
        controller: emailController,
        onChanged: (e) {},
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.grey,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 162, 156, 162), width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: "Enter Email",
            labelText: UIStrings.email,
            labelStyle: TextStyle(color: Color.fromARGB(255, 162, 156, 162))),
      );
    }

    Widget addressField() {
      return TextField(
        controller: addressController,
        onChanged: (e) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.location_city,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 162, 156, 162), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: UIStrings.address,
          labelStyle: TextStyle(color: Color.fromARGB(255, 162, 156, 162)),
        ),
      );
    }

    Widget nameField() {
      return TextField(
        onChanged: (s) {},
        controller: nameController,
        decoration: InputDecoration(
          labelText: "Enter Name",
          labelStyle: TextStyle(color: Color.fromARGB(255, 162, 156, 162)),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 162, 156, 162), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }

    Widget registerButton() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 97, 12, 90), //
          maximumSize: size * 0.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(UIStrings.register),
          ],
        ),
        onPressed: () async {
          if (validate()) {
            FocusScope.of(context).unfocus(); // dismiss keyboard

            generalLoadingDialog(context);
            registerNewUser();
            // var sCalledRegestered =
            //     await registerCallServer(phoneController.text);
            // if (sCalledRegestered) {
            //   registerNewUser();
            // } else {
            //   //call server number
            //   launch("tel://${Constants.callServerNum}");
            //   await checkForAPIResponse();
            // }
            // Navigator.pop(context);
          } else {
            Utilities.showInToast(UIStrings.fillAllField,
                toastType: ToastType.ERROR);
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text('Register'),
      ),
      // backgroundColor: Colors.grey[600],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter your phone number and tap the icon below to make a phone call.",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 40.0,
              ),
              numberField(),
              SizedBox(
                height: 30.0,
              ),
              nameField(),
              SizedBox(
                height: 30.0,
              ),
              emailField(),
              SizedBox(
                height: 30.0,
              ),
              addressField(),
              SizedBox(
                height: 30.0,
              ),
              referrelCodeField(),
              SizedBox(
                height: 30.0,
              ),
              registerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
