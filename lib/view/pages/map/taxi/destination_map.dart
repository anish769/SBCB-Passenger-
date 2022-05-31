import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pokhara_app/core/services/map_service.dart';
import 'package:pokhara_app/utils/utilities.dart';

class DestinationMapPage extends StatefulWidget {
  DestinationMapPage({this.mapState});

  MapState mapState;
  @override
  State<DestinationMapPage> createState() => _DestinationMapPageState();
}

class _DestinationMapPageState extends State<DestinationMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<String, Marker> markers = <String, Marker>{};

  TextEditingController _destinationController = TextEditingController();

  Position position;

  String street = "";

  @override
  void initState() {
    determinePosition();
    super.initState();
  }

  determinePosition() async {
    if (widget.mapState.userPosition == null) {
      var positionTest = await GeolocatorPlatform.instance.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      setState(() {
        position = positionTest;
      });
    } else {
      setState(() {
        position = widget.mapState.userPosition;
      });
    }
  }

  determineStreet(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      setState(() {
        street = placemarks[0].street;
      });

      print("Place: " + placemarks[0].street);
    } catch (e) {
      Utilities.showInToast(
          "No address information found for supplied coordinates! Please manually write street address",
          toastType: ToastType.INFO);
    }
  }

  Widget buildMapContainer(Size size) {
    return Container(
      height: size.height * 0.6,
      child: position == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 16),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              onTap: (LatLng latlng) {
                print(latlng.latitude.toString() +
                    "," +
                    latlng.longitude.toString());

                setState(() {
                  markers["outletMarker"] = Marker(
                    markerId: MarkerId("outletMarker"),
                    position: new LatLng(latlng.latitude, latlng.longitude),
                  );
                  position = Position(
                      longitude: latlng.longitude,
                      latitude: latlng.latitude,
                      timestamp: DateTime.now(),
                      accuracy: 0.0,
                      altitude: 0.0,
                      heading: 0.0,
                      speed: 0.0,
                      speedAccuracy: 0.0);
                });

                determineStreet(latlng.latitude, latlng.longitude);
              },
              onLongPress: (LatLng latlng) {
                print("LatLng: " +
                    latlng.latitude.toString() +
                    "," +
                    latlng.longitude.toString());
                setState(() {
                  markers["outletMarker"] = Marker(
                    markerId: MarkerId("outletMarker"),
                    position: new LatLng(latlng.latitude, latlng.longitude),
                  );
                  position = Position(
                      longitude: latlng.longitude,
                      latitude: latlng.latitude,
                      timestamp: DateTime.now(),
                      accuracy: 0.0,
                      altitude: 0.0,
                      heading: 0.0,
                      speed: 0.0,
                      speedAccuracy: 0.0);
                });

                determineStreet(latlng.latitude, latlng.longitude);
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text("Choose Destination From Map"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMapContainer(size),
            Text(street),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text("स्थान फेला पार्न सकेन?"),
                  TextField(
                    controller: _destinationController,
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      label: Text("आफ्नो स्थान लेख्नुहोस्"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop([position, _destinationController.text]);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 97, 12, 90),
                ),
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
