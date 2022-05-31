// import 'dart:async';
// import 'dart:convert';

// import 'package:async/async.dart' show StreamGroup;

// import 'package:flutter/material.dart';
// import 'package:flutter_animarker/flutter_map_marker_animation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_animarker/lat_lng_interpolation.dart';
// import 'package:flutter_animarker/models/lat_lng_delta.dart';
// import 'package:http/http.dart' as http;

// class DemoPage extends StatefulWidget {
//   @override
//   State<DemoPage> createState() => DemoPageState();
// }

// class DemoPageState extends State<DemoPage> {
//   Completer<GoogleMapController> _controller = Completer();

//   LatLngInterpolationStream _latLngStream = LatLngInterpolationStream();

//   // ignore: close_sinks
//   StreamGroup<LatLngDelta> subscriptions = StreamGroup<LatLngDelta>();

//   // ignore: cancel_subscriptions
//   StreamSubscription<Position> positionStream;
//   Map<String, Marker> _markers = <String, Marker>{};

//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(27.710791, 85.325251),
//     zoom: 17.4746,
//   );

//   static final CameraPosition _kLake = CameraPosition(
//       target: LatLng(27.711085949728307, 85.32408529551459),
//       zoom: 17.151926040649414);
//   @override
//   void initState() {
//     intFUnction();
//     super.initState();
//   }

//   intFUnction() async {
//     Timer.periodic(Duration(seconds: 10), (t) async {
//       var resp = await http.post(
//           'http://202.52.240.149:82/route_api_v3/public/api/private/deviceList',
//           body: {
//             'user_id': '7',
//           },
//           headers: {
//             "Authorization":
//                 "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MTY2NTUzMDgsImV4cCI6MTY0ODE5MTMwOCwianRpIjoiM3FnTU1kVGpCeXZsN1RVckRzRUtDMSIsImlkIjo3LCJtb2JpbGUiOm51bGwsIm1vYmlsZV9pZCI6bnVsbH0.Lg7GRMwUpQDWw-7tY32wepw3eNWbSEl-25ongNrVtsE"
//           });

//       print(resp);
//       var resBody = json.decode(resp.body);
//       var data = resBody['data'];
//       data.forEach((i) {
//         //Merge all the Marker Poisition Stream into a single One
//         subscriptions
//             .add(_latLngStream.getAnimatedPosition(i['deviceid'].toString()));

//         var lat = i['device']['position']['latitude'];
//         var long = i['device']['position']['longitude'];
//         _latLngStream
//             .addLatLng(LatLngInfo(lat, long, i['deviceid'].toString()));
//       });
//     });

//     subscriptions.stream.listen((LatLngDelta delta) {
//       //Update the marker with animation
//       setState(() {
//         //Get the marker Id for this animation
//         var markerId = MarkerId(delta.markerId);
//         Marker sourceMarker = Marker(
//           markerId: markerId,
//           rotation: delta.rotation,
//           position: LatLng(
//             delta.from.latitude,
//             delta.from.longitude,
//           ),
//         );
//         _markers[markerId.toString()] = sourceMarker;
//       });
//     });

//     // Future.delayed(Duration(seconds: 2), () {
//     //   updatePinOnMap();
//     // });
//   }

//   //Push new location changes, use your own position values
//   void updatePinOnMap() {
//     _latLngStream.addLatLng(LatLngInfo(27.710157, 85.324373, "Marker 1"));
//     _latLngStream.addLatLng(LatLngInfo(27.710846, 85.324389, "Marker 1"));
//     _latLngStream.addLatLng(LatLngInfo(27.711304, 85.324516, "Marker 1"));
//     _latLngStream.addLatLng(LatLngInfo(27.711268, 85.325279, "Marker 1"));
//   }

//   @override
//   void dispose() {
//     subscriptions.close();
//     positionStream.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(DateTime.now().toString());
//     return new Scaffold(
//       body: GoogleMap(
//         onTap: (v) {
//           _latLngStream
//               .addLatLng(LatLngInfo(v.latitude, v.longitude, "Marker 1"));
//         },
//         markers: Set<Marker>.of(_markers.values),
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: Text('To the lake!'),
//         icon: Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
