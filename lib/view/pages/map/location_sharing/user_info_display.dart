import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/user_data/user.dart';
import 'package:pokhara_app/utils/constants.dart';

class UserInfoDisplay extends StatelessWidget {
  final User user;

  const UserInfoDisplay({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        height: 40,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Text(
                    ' ' + user.name.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget image() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: ClipOval(
              child: user.profileImage != null
                  ? Image.network(
                      user.profileImage,
                    )
                  : Image.asset(
                      Assets.appLogo,
                    ),
            ),
          ),
        ),
      );
    }

    Widget descriptionWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.mobileNumber,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    showinfoDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              insetAnimationCurve: Curves.easeIn,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  // height: height * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header(),
                      image(),
                      descriptionWidget(),
                    ],
                  ),
                ),
              ));
        },
      );
    }

    return GestureDetector(
      onTap: () {
        showinfoDialog();
      },
      child: Stack(
        children: [
          Icon(
            Icons.location_pin,
            size: 40,
          ),
          Container(
            child: CircleAvatar(
                backgroundImage: user.profileImage != null
                    ? NetworkImage(
                        user.profileImage,
                      )
                    : AssetImage(
                        Assets.appLogo,
                      )),
          ),
        ],
      ),
    );
  }
}
