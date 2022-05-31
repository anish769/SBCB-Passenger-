// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:pokhara_app/core/models/vehicles/public_vehicle.dart';

// class DetailView extends StatefulWidget {
//   final PublicVehicle device;

//   DetailView({
//     @required this.device,
//   });

//   @override
//   _DetailViewState createState() => _DetailViewState();
// }

// class _DetailViewState extends State<DetailView> {
//   var address = 'Fetching address..';
//   @override
//   void initState() {
//     super.initState();
//     Geolocator()
//         .placemarkFromCoordinates(
//             widget.device.latitude, widget.device.longitude)
//         .then((value) {
//       print(value);
//       setState(() {
//         address = value.first.subLocality + ', ' + value.first.name;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _height = MediaQuery.of(context).size.height;
//     final _width = MediaQuery.of(context).size.width;

//     dialogTitle() {
//       return Column(
//         children: <Widget>[
//           Container(
//             height: _height * 0.06,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.drive_eta,
//                     size: 20,
//                     color: Colors.amber,
//                   ),
//                   SizedBox(
//                     width: 12.0,
//                   ),
//                   Text(
//                     widget.device.name,
//                     style: TextStyle(color: Colors.white, fontSize: 17.0),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     Widget listTiles() {
//       return Container(
//         width: _width, // Change as per your requirement

//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               ListTile(
//                 leading: new Icon(
//                   Icons.linear_scale,
//                   size: 23.0,
//                   color: Colors.amber,
//                 ),
//                 title: Text(
//                   widget.device.distance.toStringAsFixed(2) + " k.m",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 subtitle: Text(
//                   "Distance",
//                   style: TextStyle(color: Colors.white, fontSize: 13),
//                 ),
//               ),
//               ListTile(
//                 leading: new Icon(
//                   Icons.graphic_eq,
//                   size: 23.0,
//                   color: Colors.amber,
//                 ),
//                 title: Text(
//                   (widget.device.speed.toString()) + "  km/h",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 subtitle: Text(
//                   "speed",
//                   style: TextStyle(color: Colors.white, fontSize: 13),
//                 ),
//               ),
//               ListTile(
//                 leading: new Icon(
//                   Icons.location_on,
//                   size: 23.0,
//                   color: Colors.amber,
//                 ),
//                 title: Text(
//                   address,
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 subtitle: Text(
//                   "Current Location",
//                   style: TextStyle(color: Colors.white, fontSize: 13),
//                 ),
//               ),
//               // ListTile(
//               //   leading: new Icon(
//               //     Icons.timer,
//               //     size: 23.0,
//               //     color: Colors.amber,
//               //   ),
//               //   title: Text(
//               //   ("temp"),
//               //     style: TextStyle(color: Colors.white, fontSize: 14),
//               //   ),
//               //   subtitle: Text(
//               //     "अन्तिम अनलाइन",
//               //     style: TextStyle(color: Colors.white, fontSize: 13),
//               //   ),
//               // ),
//               if (widget.device.routeName != "")
//                 ListTile(
//                   leading: new Icon(
//                     Icons.show_chart,
//                     size: 23.0,
//                     color: Colors.amber,
//                   ),
//                   title: Text(
//                     widget.device.routeName,
//                     style: TextStyle(color: Colors.white, fontSize: 15),
//                   ),
//                   subtitle: Text(
//                     "route",
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       );
//     }

//     return AlertDialog(
//       backgroundColor: Theme.of(context).primaryColor, // Colors.blue.shade900,
//       title: dialogTitle(),
//       content: listTiles(),
//     );
//   }
// }
