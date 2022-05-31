import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MapAttrib {
  final LatLng swPanBoundary;
  final LatLng nePanBoundary;
  final LatLng center;
  final Position defaultPos;
  final Future<String> mapLocalPath;
  final String mapAssetPath;
  final String name;

  MapAttrib(
      {this.swPanBoundary,
      this.nePanBoundary,
      @required this.center,
      this.defaultPos,
      this.mapLocalPath,
      this.mapAssetPath,
      @required this.name});
}

final mapAttribs = [
  ///Kathmandu
  MapAttrib(
    name: 'Kathmandu',
    center: LatLng(27.7192072, 85.310929),
  ),

  // ///Pokhara
  MapAttrib(
    name: 'Pokhara',
    center: LatLng(28.199987, 83.982803),
  ),

  ///Mugling
  MapAttrib(
    name: 'Mugling',
    center: LatLng(27.856093, 84.560770),
  ),

  ///Palpa
  MapAttrib(
    name: 'Palpa',
    center: LatLng(27.823438, 83.618258),
  ),

  ///Baglung
  MapAttrib(
    name: 'Baglung',
    center: LatLng(28.272530, 83.598682),
  ),

  ///Jomsom
  MapAttrib(
    name: 'Jomsom',
    center: LatLng(28.7818535, 83.7213825),
  ),

  ///Kusma
  MapAttrib(
    name: 'Kusma',
    center: LatLng(28.2201298, 83.6808797),
  ),

  ///Beni
  MapAttrib(
    name: 'Beni',
    center: LatLng(28.357291, 83.543601),
  ),

  ///Dulegauda
  MapAttrib(
    name: 'Dulegauda',
    center: LatLng(28.0640665, 84.0519801),
  ),

  ///Nayapool
  MapAttrib(
    name: 'Nayapool',
    center: LatLng(28.2394679, 83.6416717),
  ),

  ///Damauli
  MapAttrib(
    name: 'Damauli',
    center: LatLng(27.987588, 84.282217),
  ),

  ///Syangja
  MapAttrib(
    name: 'Syangja',
    center: LatLng(28.059209, 83.807038),
  ),
];
