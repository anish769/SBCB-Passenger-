import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/core/services/map_service.dart';
import 'package:pokhara_app/demo.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/map/map_attrib.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/hamro_krishi_home.dart';
import 'package:pokhara_app/view/pages/map/taxi/taxi_map.dart';
import 'package:pokhara_app/view/pages/profile/profile_page.dart';
import 'package:pokhara_app/view/pages/ad/search_page.dart';
import 'package:pokhara_app/view/pages/rental_car/rental_home.dart';
import 'package:pokhara_app/view/pages/settings.dart';
import 'package:provider/provider.dart';

import '../webview.dart';

class MenuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // getting the size of the window

    var provider = Provider.of<MapState>(context, listen: false);

    Widget gridItem(String name, String description, String image, Widget page,
        {IconData inbuiltIcon}) {
      return InkWell(
        enableFeedback: true,
        child: Card(
          elevation: 2,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: page is ProfilePage
                          ? image != null
                              ? NetworkImage(image)
                              : AssetImage(Assets.defaultUserIcon)
                          : null,
                      radius: 26,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: inbuiltIcon == null
                          ? SizedBox()
                          : Hero(
                              tag: name,
                              child: Icon(
                                inbuiltIcon,
                                size: 23,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      name ?? 'User',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 14,
                      thickness: 1.5,
                      endIndent: 22,
                      indent: 22,
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          var pageDetails;

          if (page is TaxiMapPage) {
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    title: Center(child: Text('Select Location')),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // for local
                        Container(
                          child: FlatButton(
                              color: Color.fromARGB(255, 97, 12, 90),
                              textColor: Colors.white,
                              onPressed: () async {
                                if (provider.userPosition != null) {
                                  pageDetails = MapAttrib(
                                    name: "Local",
                                    center: LatLng(
                                        provider.userPosition.latitude,
                                        provider.userPosition.longitude),
                                  );
                                } else {
                                  Utilities.showInToast(
                                      "Could not get user Location");
                                }
                                Navigator.pop(context);
                              },
                              child: Text("Local")),
                        ),
                        Divider(thickness: 5.0),
                        Text("Long Route"),
                        // for long route
                        Container(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              for (var item in mapAttribs)
                                SizedBox(
                                  width: 160,
                                  child: FlatButton(
                                      color: Color.fromARGB(255, 97, 12, 90),
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        pageDetails = item;
                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                      child: Text(item.name)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            if (pageDetails == null) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        Consumer<MapState>(builder: (context, mapState, child) {
                          return TaxiMapPage(
                            attrib: pageDetails,
                            mapState: mapState,
                          );
                        })));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          }
        },
      );
    }

    Widget gridBar() {
      return Consumer<AuthState>(
        builder: (context, state, child) {
          var user = state.credentials.user;
          return SingleChildScrollView(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              children: <Widget>[
                gridItem(
                  user.name,
                  UIStrings.profile,
                  user.profileImage,
                  ProfilePage(),
                ),
                Container(
                  child: gridItem(
                      UIStrings.taxiBooking,
                      UIStrings.bookTaxi,
                      "image",
                      TaxiMapPage(
                        attrib: null,
                        // mapState:
                      ),
                      inbuiltIcon: Icons.local_taxi),
                ),
                Container(
                  child: gridItem(UIStrings.sbcbKrishi,
                      UIStrings.hamroKrishiSub, "image", HamroKrishiHomePage(),
                      inbuiltIcon: Icons.food_bank_outlined),
                ),
                Container(
                  child: gridItem(UIStrings.sbcbRental, UIStrings.sbcbRentalSub,
                      "image", RentalCarHomePage(),
                      inbuiltIcon: Icons.car_rental),
                ),
                Container(
                  child: gridItem(UIStrings.transport, UIStrings.transport,
                      "image", DemoPage(),
                      inbuiltIcon: Icons.local_shipping),
                ),
                Container(
                  child: gridItem(UIStrings.settings, UIStrings.settings,
                      "image", SettingsPage(),
                      inbuiltIcon: Icons.settings),
                ),
                Container(
                  child: gridItem(UIStrings.search, UIStrings.exploreAds,
                      "image", SearchPage(),
                      inbuiltIcon: Icons.search),
                ),
                Container(
                  child: gridItem(
                      UIStrings.webview, UIStrings.webview, "image", WebViews(),
                      inbuiltIcon: Icons.web),
                )
              ],
            ),
          );
        },
      );
    }

    return gridBar();
  }
}
