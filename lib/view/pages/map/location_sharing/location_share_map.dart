// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong/latlong.dart';
// import 'package:pokhara_app/core/models/user_data/location_share_data.dart';
// import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
// import 'package:pokhara_app/utils/ui_strings.dart';
// import 'package:pokhara_app/utils/utilities.dart';
// import 'package:pokhara_app/view/pages/map/location_sharing/share_view.dart';
// import 'package:pokhara_app/view/pages/map/location_sharing/user_info_display.dart';
// import 'package:provider/provider.dart';

// class LocationSharingMap extends StatefulWidget {
//   @override
//   _LocationSharingMapState createState() => _LocationSharingMapState();
// }

// class _LocationSharingMapState extends State<LocationSharingMap> {
//   final double minZoom = 12.0, maxZoom = 19.0, midZoom = 14.0;

//   Position userPosition;
//   Map<String, Marker> markers = <String, Marker>{};

//   Position defaultPosition =
//       Position(latitude: 27.721925, longitude: 85.3226459);

//   final MapController mapController = MapController();
//   List<LocationShareData> friends = [];

//   Timer taxiTimer;

//   @override
//   void initState() {
//     iniFuntion();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     taxiTimer?.cancel();
//     super.dispose();
//   }

//   iniFuntion() async {
//     var pos = await getUserLocation();
//     showUserPin();
//     if (pos != null) {
//       getShareData();
//       taxiTimer = Timer.periodic(Duration(seconds: 55), (Timer t) {
//         getShareData();
//       });
//     }
//   }

//   getShareData() async {
//     var connected = await Utilities.isInternetWorking();
//     if (!connected) return;

//     var data = await getLocationShareDataAPI(
//         userPosition.latitude, userPosition.longitude, '');

//     if (data == null) return;

//     data.forEach((val) {
//       var userMarker = new Marker(

//           // width: 80.0,
//           // height: 80.0,
//           point: new LatLng(
//               val.user.position.latitude, val.user.position.longitude),
//           builder: (ctx) => UserInfoDisplay(user: val.user));

//       setState(() {
//         markers[val.user.id.toString()] = userMarker;
//       });
//     });
//   }

//   Future<Position> getUserLocation() async {
//     var isLocationTurnedOn = await Geolocator().isLocationServiceEnabled();

//     if (isLocationTurnedOn) {
//       var pos = await Geolocator().getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//           locationPermissionLevel: GeolocationPermission.locationWhenInUse);
//       if (pos != null) {
//         setState(() {
//           userPosition = pos;
//         });

//         print("last known user location is: \n" + userPosition.toString());
//       }
//       return pos;
//     } else {
//       Utilities.showPlatformSpecificAlert(
//           title: "Waring",
//           body:
//               "Your location services are disabled. \nPlease turn on your location services.",
//           context: context);
//       return null;
//     }
//   }

//   showUserPin() async {
//     if (userPosition != null) {
//       var state = Provider.of<AuthState>(context, listen: false).credentials;
//       var user = state.user;

//       var userMarker = new Marker(
//           // width: 80.0,
//           // height: 80.0,
//           point: new LatLng(userPosition.latitude, userPosition.longitude),
//           builder: (ctx) => UserInfoDisplay(user: user));

//       mapController.move(
//           LatLng(userPosition.latitude, userPosition.longitude), maxZoom);
//       setState(() {
//         markers['user'] = userMarker;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget _mapView() {
//       return Column(
//         children: [
//           Expanded(
//             child: FlutterMap(
//               mapController: mapController,
//               options: MapOptions(
//                 boundsOptions: FitBoundsOptions(),
//                 slideOnBoundaries: true,
//                 controller: mapController,
//                 center: LatLng(27.7192072, 85.310929),
//                 interactive: true,
//                 onLongPress: (_) {
//                   print('long pressed');
//                 },
//                 minZoom: 12.0,
//                 maxZoom: 20.0,
//                 zoom: 14.0,
//                 swPanBoundary: LatLng(27.677435, 85.271079),
//                 nePanBoundary: LatLng(27.747913, 85.366264),
//               ),
//               layers: [
//                 // TileLayerOptions(
//                 //   tileProvider: AssetTileProvider(),
//                 //   maxZoom: 19.0,
//                 //   urlTemplate: 'assets/map/OSM_tiles/{z}/{x}/{y}.png',
//                 //   subdomains: ['a', 'b', 'c'],
//                 // ),
//                 TileLayerOptions(
//                     tileProvider:
//                         MBTilesImageProvider.fromAsset("Assets.mapFile"),
//                     subdomains: ['a', 'b', 'c'],
//                     minZoom: 12,
//                     maxNativeZoom: 19,
//                     minNativeZoom: 12,
//                     maxZoom: 20.0,
//                     backgroundColor: Colors.transparent,
//                     tms: true),
//                 new MarkerLayerOptions(
//                   markers: Set<Marker>.of(markers.values).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(UIStrings.locationSharing),
//       ),
//       body: Stack(children: [
//         _mapView(),

//         //share button
//         if (userPosition != null)
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: FlatButton.icon(
//                 color: Theme.of(context).primaryColor,
//                 textColor: Colors.white,
//                 onPressed: () async {
//                   var res = await showModalBottomSheet(
//                       isDismissible: false,
//                       context: context,
//                       builder: (BuildContext bc) {
//                         return ShareView();
//                       });
//                   print(res);
//                   if (res != null) {
//                     shareMyLocationAPI(res).then((value) {});
//                   }
//                 },
//                 icon: Icon(Icons.share, color: Colors.white),
//                 label: Text('Share')),
//           )
//       ]),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         heroTag: "location",
//         onPressed: () async {
//           await getUserLocation();
//           showUserPin();
//         },
//         child: Icon(Icons.my_location),
//       ),
//     );
//   }
// }
