// import 'package:flutter/material.dart';
// import 'package:pokhara_app/core/models/vehicles/public_vehicle.dart';
// import 'package:pokhara_app/utils/constants.dart';
// import 'package:pokhara_app/view/widgets/detail_view.dart';

// class DeviceIcon extends StatelessWidget {
// //ignore: must_be_immutable

//   final PublicVehicle device;

//   DeviceIcon({this.device});

//   String _color() {
//     var name = device.name.toUpperCase();
//     if (name.contains('MAHANAGAR'))
//       return Assets.redBus;
//     else if (name.contains('SAJHA'))
//       return Assets.greenBus;
//     else if (name.contains('DIGO'))
//       return Assets.blueBus;
//     else
//       return Assets.orangeBus;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Transform.rotate(
//       angle: device.course.toDouble(), //course rotation
//       child: InkWell(
//           onTap: () {
//             print(device.toJson());
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return DetailView(device: device);
//                 });
//           },
//           child: Image.asset(_color())),
//     );
//   }
// }
