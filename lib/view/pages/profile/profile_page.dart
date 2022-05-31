import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final bool editMode;

  const ProfilePage({Key key, this.editMode = false}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editMode;
  User user, changedUser;

  final TextEditingController email = new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController phone = new TextEditingController();
  final TextEditingController joinDate = new TextEditingController();

  @override
  void initState() {
    _editMode = widget.editMode;
    super.initState();
    var state = Provider.of<AuthState>(context, listen: false);
    user = state.credentials.user;
    changedUser = User.fromJson(user.toJson());

    print(user);
    setupValues();
  }

  setupValues() {
    email.text = user.email;
    name.text = user.name;
    address.text = user.address;
    phone.text = user.mobileNumber;
    joinDate.text = user.registrationDate.split(' ').first;
  }

  // void _onRefresh() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 2000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }

  Future<String> _getImg(ImageSource src) async {
    String base64Image = '';
    var img = await ImagePicker().getImage(source: src, imageQuality: 50);
    Navigator.pop(context);
    if (img != null) {
      List<int> imageBytes = await img.readAsBytes();
      base64Image = base64Encode(imageBytes);
      var state = Provider.of<AuthState>(context, listen: false);
      Utilities.showPlatformSpecificAlert(
          context: context,
          title: "Uploading",
          dismissable: false,
          body: "Please wait while the image is uploading");

      var res = await state.updateUserPicture(base64Image);
      Navigator.pop(context);

      if (res) {
        Utilities.showInToast("Picture updated Successfult",
            toastType: ToastType.SUCCESS);
        setState(() {
          _editMode = false;
        });
      } else {
        Utilities.showInToast("Failed to update picture.",
            toastType: ToastType.ERROR);
      }
    }

    return base64Image;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getImg(ImageSource.gallery);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getImg(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget emailField() {
      return TextField(
        controller: email,
        onChanged: (e) {
          changedUser.email = e;
        },
        enabled: _editMode,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Container(
                height: 20,
                width: 20,
                child: FadedTransition(
                  icon: Icon(
                    Icons.email,
                  ),
                  animate: _editMode,
                )),
            hintText: "Enter Email",
            labelText: UIStrings.email,
            enabled: _editMode),
      );
    }

    Widget phoneField() {
      return TextField(
        controller: phone,
        enabled: false,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone_iphone),
            hintText: "9876543210",
            labelText: UIStrings.mobNum,
            enabled: _editMode),
      );
    }

    Widget joinedField() {
      return TextField(
        controller: joinDate,
        enabled: false,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today),
            hintText: "",
            labelText: UIStrings.joined,
            enabled: _editMode),
      );
    }

    Widget addressField() {
      return TextField(
        controller: address,
        onChanged: (e) {
          changedUser.address = e;
        },
        enabled: _editMode,
        decoration: InputDecoration(
            prefixIcon: Container(
                height: 20,
                width: 20,
                child: FadedTransition(
                  icon: Icon(
                    Icons.location_city,
                  ),
                  animate: _editMode,
                )),
            hintText: "Enter Address",
            labelText: UIStrings.address,
            enabled: _editMode),
      );
    }

    Widget nameField() {
      return TextField(
        onChanged: (s) {
          changedUser.name = s;
        },
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        controller: name,
        enabled: _editMode,
        decoration: InputDecoration(
          hintText: "Enter Name",
          border: InputBorder.none,
          enabled: _editMode,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: _editMode
            ? FloatingActionButton.extended(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  FocusScope.of(context).unfocus(); // dismiss keyboard
                  var isConnected = await Utilities.isInternetWorking();
                  if (isConnected) {
                    //TODO: check validation

                    var state = Provider.of<AuthState>(context, listen: false);
                    Utilities.showPlatformSpecificAlert(
                        context: context,
                        title: "Updating profile",
                        dismissable: false,
                        body: "Please wait...");

                    state.updateUser(changedUser).then((success) {
                      Navigator.pop(context);
                      if (success) {
                        setState(() {
                          _editMode = false;
                        });
                        Utilities.showInToast("Successfully updated",
                            toastType: ToastType.SUCCESS);
                      } else {
                        Utilities.showInToast("Error while updating.",
                            toastType: ToastType.ERROR);
                      }
                    });
                  } else {
                    Utilities.showInToast("No connection!",
                        toastType: ToastType.ERROR);
                  }
                },
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.save),
                    Text(" " + UIStrings.save),
                  ],
                ))
            : SizedBox(),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 97, 12, 90),
          title: Text(UIStrings.profile),
          actions: <Widget>[
            IconButton(
              icon: Icon(_editMode ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _editMode = !_editMode;
                  setupValues();
                });
              },
            )
          ],
        ),
        body: Consumer<AuthState>(builder: (context, state, child) {
          var user = state.credentials.user;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'img',
                    child: GestureDetector(
                      onTap: () async {
                        if (!_editMode) return;
                        _showPicker(context);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 80,
                            backgroundImage: user.profileImage != null &&
                                    user.profileImage.isNotEmpty
                                ? NetworkImage(
                                    user.profileImage,
                                  )
                                : AssetImage(Assets.appLogo),
                          ),
                          if (_editMode)
                            Positioned(
                              right: 5,
                              bottom: 5,
                              child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(Icons.photo)),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                nameField(),

                // Text(
                //   user.name ?? 'User',
                //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                // ),
                emailField(),
                phoneField(),
                addressField(),
                joinedField(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class FadedTransition extends StatefulWidget {
  final Widget icon;
  final bool animate;

  const FadedTransition({Key key, @required this.icon, @required this.animate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _Fade();
}

class _Fade extends State<FadedTransition> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 0.5).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: widget.animate
              ? FadeTransition(
                  opacity: _fadeInFadeOut,
                  child: widget.icon,
                )
              : widget.icon,
        ),
      ),
    );
  }
}
