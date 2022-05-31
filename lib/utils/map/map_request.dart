import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokhara_app/utils/constants.dart';

class GoogleMapsServices {
  Future<Map> getRouteCoordinates(LatLng origin, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${Constants.googleAPIKey}";
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    return values;
  }
}
