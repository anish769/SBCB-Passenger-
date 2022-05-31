// import 'package:flutter/material.dart';
// import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
// import 'package:pokhara_app/utils/constants.dart';
// import 'package:pokhara_app/utils/ui_strings.dart';
// import 'package:pokhara_app/utils/utilities.dart';
// import 'package:pokhara_app/view/pages/about_us.dart';
// import 'package:pokhara_app/view/pages/map/taxi/taxi_map.dart';
// import 'package:pokhara_app/view/pages/profile/profile_page.dart';
// import 'package:pokhara_app/view/pages/settings.dart';
// import 'package:pokhara_app/view/widgets/terms_condition.dart';
// import 'package:provider/provider.dart';

// class AppDrawer extends StatelessWidget {
//   final Size size;

//   const AppDrawer({Key key, this.size}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     void _navigateTo(Widget page) {
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
//     }

//     Widget _drawerItem(IconData icon, String title, Widget page) {
//       return ListTile(
//         leading: Icon(icon),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 0.6),
//         ),
//         onTap: () => _navigateTo(page),
//       );
//     }

//     Widget logoutButton(AuthState state) {
//       return Container(
//         color: Theme.of(context).primaryColor,
//         child: ListTile(
//             leading: Icon(
//               Icons.exit_to_app,
//               color: Colors.white,
//             ),
//             title: Text(
//               UIStrings.logout,
//               style: TextStyle(color: Colors.white),
//             ),
//             onTap: () {
//               Utilities.showPlatformSpecificAlert(
//                   title: UIStrings.logout,
//                   body: UIStrings.confirmLogout,
//                   context: context,
//                   addionalAction: DialogAction(
//                       label: UIStrings.logout,
//                       onPressed: () {
//                         Navigator.of(context).pop();

//                         state.signOut();
//                       }));
//             }),
//       );
//     }

//     return Container(
//         width: size.width * 0.62,
//         child: Consumer<AuthState>(
//           builder: (context, state, child) {
//             var user = state.credentials.user;
//             return Drawer(
//               child: Column(
//                 children: <Widget>[
//                   UserAccountsDrawerHeader(
//                     currentAccountPicture: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: user.profileImage != null
//                           ? NetworkImage(user.profileImage)
//                           : AssetImage(Assets.appLogo),
//                     ),
//                     accountName: Text(user.name ?? UIStrings.noName),
//                     accountEmail: Text(user.email ?? UIStrings.noEmail),
//                     onDetailsPressed: () {
//                       _navigateTo(ProfilePage());
//                     },
//                   ),
//                   // _drawerItem(
//                   //     Icons.directions_bus, UIStrings.localBus, MapPage()),
//                   // _drawerItem(
//                   //     Icons.local_taxi, UIStrings.taxiBooking, TaxiMapPage()),
//                   // _drawerItem(Icons.time_to_leave, UIStrings.privateVehicle,
//                   //     PrivateVehicleLogin()),
//                   // _drawerItem(Icons.my_location, UIStrings.locationSharing,
//                   //     LocationSharingMap()),
//                   // _drawerItem(Icons.share, "Share", MapPage()),
//                   _drawerItem(Icons.vpn_key, UIStrings.privacyPolicy,
//                       TermsConditions()),
//                   _drawerItem(Icons.contact_mail, UIStrings.aboutUs, AboutUs()),
//                   _drawerItem(
//                       Icons.settings, UIStrings.settings, SettingsPage()),
//                   Spacer(),
//                   logoutButton(state)
//                 ],
//               ),
//             );
//           },
//         ));
//   }
// }
