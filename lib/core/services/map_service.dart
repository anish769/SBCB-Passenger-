import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pokhara_app/utils/map/map_attrib.dart';
import 'package:pokhara_app/utils/map/map_request.dart';

class MapState extends ChangeNotifier {
  String _lastKnownLocation = "";
  Position _userPosition;
  // LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Map<String, Marker> _markers = <String, Marker>{};
  Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  bool disableMoveMarker = false;
  MapType mapType = MapType.normal;
  MapAttrib mapAttrib;

  Position get userPosition => _userPosition;
  // LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Map<String, Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  String get lastKnownLocation => _lastKnownLocation;

  MapState() {
    _getUserLocation();
  }

  changeMapType(MapType newMapType) {
    mapType = newMapType;

    notifyListeners();
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    clearRoute();
    _polyLines.add(
      Polyline(
        polylineId: PolylineId(_userPosition.toString()),
        width: 5,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black,
        geodesic: true,
      ),
    );
    disableMoveMarker = true;
    notifyListeners();
  }

  void clearRoute() {
    _polyLines.clear();
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! SEND REQUEST
  void sendRequest(LatLng source, LatLng destination) async {
    print("Inside send Request");
    var route = await googleMapsServices
        .getRouteCoordinates(source, destination)
        .toString();
    createRoute(route);
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // ! TO GET THE USERS LOCATION
  _getUserLocation() {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((Position position) {
      _userPosition = position;
      notifyListeners();
    });
  }

  void animateCameraToDesireLocation(LatLng destination) {
    final GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: 15)));
    notifyListeners();
  }
}
