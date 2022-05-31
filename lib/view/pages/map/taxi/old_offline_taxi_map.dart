// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong/latlong.dart';
// import 'package:pokhara_app/core/models/vehicles/taxi/taxi_request.dart';
// import 'package:pokhara_app/core/models/vehicles/taxi/taxi.dart';
// import 'package:pokhara_app/utils/constants.dart';
// import 'package:pokhara_app/utils/map/map_attrib.dart';
// import 'package:pokhara_app/utils/utilities.dart';
// import 'package:pokhara_app/view/pages/map/taxi/taxi_rating.dart';
// import 'package:pokhara_app/view/pages/map/taxi/taxi_requesting_view.dart';
// import 'package:pokhara_app/view/pages/map/taxi/taxi_request_view.dart';

// class TaxiMapPage extends StatefulWidget {
//   final MapAttrib attrib;

//   const TaxiMapPage({Key key, @required this.attrib}) : super(key: key);
//   @override
//   _TaxiMapPageState createState() => _TaxiMapPageState();
// }

// class _TaxiMapPageState extends State<TaxiMapPage> {
//   int refreshSec = 10; //seconds
//   final double minZoom = 12.0, maxZoom = 19.0, midZoom = 14.0;
//   bool _activeTrip = false;
//   Taxi _activeTaxi;

//   final MapController mapController = MapController();

//   Position userPosition;

//   Map<String, Marker> markers = <String, Marker>{};

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
//     var x = widget.attrib;
//     var pos = await getUserLocation();
//     if (pos != null) {
//       getTaxis();
//       taxiTimer = Timer.periodic(Duration(seconds: refreshSec), (Timer t) {
//         getTaxis();
//       });
//     }
//   }

//   getTaxis() async {
//     var connected = await Utilities.isInternetWorking();
//     if (!connected) return;

//     var taxis =
//         await getTaxisAPI(userPosition.latitude, userPosition.longitude);
//     print('taxi refreshed');
//     markers.clear();

//     if (taxis == null) return;
//     if (_activeTrip) {
//       // var res = taxis.where((element) => element.name == ('ba1ja1')).toList();
//       var res =
//           taxis.where((element) => element.name == _activeTaxi.name).toList();
//       taxis = res;
//     }
//     // var res = taxis.where((element) => element.name == ('ba1ja1')).toList();

//     // taxis = res;

//     taxis.forEach((taxi) {
//       var userMarker = new Marker(

//           // width: 80.0,
//           // height: 80.0,
//           point: new LatLng(taxi.latitude, taxi.longitude),
//           builder: (ctx) => GestureDetector(
//                 onTap: () async {
//                   //location should be avialable for taxi request
//                   if (userPosition == null) {
//                     Utilities.showInToast('Please turn on your location',
//                         toastType: ToastType.ERROR);
//                     return;
//                   }

//                   //check if taxi is in the middle of trip
//                   //if not thean request it

//                   _activeTrip ? showTaxiInfo(taxi) : requestTaxi(taxi);
//                 },
//                 child: Image.asset(Assets.taxi),
//                 // child: Container(
//                 //   color: Colors.black,
//                 //   width: 800,
//                 //   height: 700,
//                 // )
//               ));
//       if (this.mounted)
//         setState(() {
//           markers[taxi.uniqueId] = userMarker;
//         });
//     });
//   }

//   requestTaxi(Taxi taxi) async {
//     //show input dialog
//     TaxiRequest req = await showDialog(
//       context: context,
//       builder: (context) => TaxiRequestView(taxi: taxi),
//     );

//     if (req != null) {
//       req.latitude = userPosition.latitude.toString();
//       req.longitude = userPosition.longitude.toString();
//       req.clientId = taxi.deviceId.toString();

//       //show requesting dialog
//       var response = await showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => TaxiRequestingView(
//           taxi: taxi,
//           request: req,
//         ),
//       );

//       if (response == null) return;
//       if (response.isAccepted == 1) {
//         //start trip
//         print('starting trip');
//         startTrip(taxi);
//       }
//     }
//   }

//   showTaxiInfo(Taxi taxi) {}

//   startTrip(Taxi selectedTaxi) {
//     setState(() {
//       _activeTaxi = selectedTaxi;
//       _activeTrip = true;
//     });
//     getTaxis();
//   }

//   endTrip() async {
//     print('ending');
//     await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => TaxiRatingView(taxi: _activeTaxi),
//     );
//     setState(() {
//       _activeTaxi = null;
//       _activeTrip = false;
//     });
//     getTaxis();
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
//     setState(() {
//       userPosition = widget.attrib.defaultPos;
//     });
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
//                 controller: mapController,
//                 center: widget.attrib.center,

//                 // pkrcenter: LatLng(28.199987, 83.982803),
//                 interactive: true,
//                 onLongPress: (_) {
//                   print('long pressed');
//                 },
//                 minZoom: minZoom,
//                 maxZoom: maxZoom,
//                 zoom: midZoom,
//                 swPanBoundary: widget.attrib.swPanBoundary,
//                 nePanBoundary: widget.attrib.nePanBoundary,
//               ),
//               layers: [
//                 TileLayerOptions(
//                     tileProvider: MBTilesImageProvider.fromAsset(
//                         // 'assets/map/ktm.mbtiles'),
//                         widget.attrib.mapAssetPath),
//                     subdomains: ['a', 'b', 'c'],
//                     urlTemplate: widget.attrib.mapAssetPath,
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

//     return SafeArea(
//       child: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Theme.of(context).primaryColor,
//           heroTag: "location",
//           onPressed: () async {
//             await getUserLocation();
//             if (userPosition != null) {
//               var userMarker = new Marker(
//                 // width: 80.0,
//                 // height: 80.0,
//                 point:
//                     new LatLng(userPosition.latitude, userPosition.longitude),
//                 builder: (ctx) => Icon(Icons.person_pin_circle,
//                     color: Colors.black, size: 50),
//               );

//               mapController.move(
//                   LatLng(userPosition.latitude, userPosition.longitude),
//                   maxZoom);
//               setState(() {
//                 markers['user'] = userMarker;
//               });
//             }
//           },
//           child: Icon(Icons.my_location),
//         ),
//         body: Stack(
//           children: <Widget>[
//             _mapView(),
//             if (!_activeTrip)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: CircleAvatar(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     child: BackButton(),
//                   ),
//                 ),
//               ),
//             if (_activeTrip)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: MaterialButton(
//                     color: Colors.green[700],
//                     textColor: Colors.white,
//                     onPressed: () {
//                       endTrip();
//                     },
//                     child: Text('End trip'),
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
