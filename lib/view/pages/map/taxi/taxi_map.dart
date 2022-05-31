import 'dart:convert';
import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi_request.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/core/notifiers/providers/taxi_state.dart';
import 'package:pokhara_app/core/services/map_service.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/map/map_attrib.dart';
import 'package:pokhara_app/utils/map/map_request.dart';
import 'package:pokhara_app/utils/utilities.dart';

import 'package:pokhara_app/view/pages/map/taxi/taxi_rating.dart';
import 'package:pokhara_app/view/pages/map/taxi/taxi_requesting_view.dart';
import 'package:pokhara_app/view/pages/map/taxi/taxi_request_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/vehicles/taxi/taxi_response.dart';
import '../../../../core/models/vehicles/taxi/topic.dart';

class TaxiMapPage extends StatefulWidget {
  final MapAttrib attrib;
  final MapState mapState;

  const TaxiMapPage({Key key, @required this.attrib, this.mapState})
      : super(key: key);
  @override
  _TaxiMapPageState createState() => _TaxiMapPageState();
}

class _TaxiMapPageState extends State<TaxiMapPage> {
  int refreshSec = 10; //seconds

  int finalRate = 0;
  double distance = 0.0;
  final double minZoom = 12.0, maxZoom = 19.0, midZoom = 15.0;
  bool _activeTrip = false;
  bool _locationPicked = false;
  bool cameraMoving = false;
  bool enablePathaoMode = false;
  bool disableMoveMarker = false;
  bool isTaxiRequesting = false;
  Taxi _activeTaxi;
  BitmapDescriptor taxiIcon;
  BitmapDescriptor bikeIcon;
  Marker destinationMarker;
  int currentIndex = 0;

  //list of widgets to call ontap

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

// Create a page controller to change page programmatically

  String rate = "";

  TextEditingController destinationController = TextEditingController();

  GoogleMapsServices googleMapsServices = GoogleMapsServices();

  Map<String, Marker> markers = <String, Marker>{};

  Timer taxiTimer;

  LatLng source;
  LatLng destination;

  String locality = "";
  String city = "";
  String vehicleType = VehicleType.both;

  String destinationText = "Search Destination";

  TaxiRequest finalTaxiRequest = TaxiRequest();
  Taxi finalTaxi;
  TaxiResponse taxiResponse = TaxiResponse();

  @override
  void initState() {
    iniFuntion();
    super.initState();
  }

  @override
  void dispose() {
    taxiTimer?.cancel();
    super.dispose();
  }

  iniFuntion() async {
    // var provider = Provider.of<MapState>(context, listen: false);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.mapState.userPosition.latitude,
          widget.mapState.userPosition.longitude);
      setState(() {
        locality = placemarks[0].thoroughfare;
        city = placemarks[0].locality;
      });
    } catch (e) {
      print(e);
    }

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
        size: Size(1000, 1000),
      ),
      Assets.taxi,
    ).then((onValue) {
      taxiIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
        size: Size(1000, 1000),
      ),
      Assets.bike,
    ).then((onValue) {
      bikeIcon = onValue;
    });

    // add marker if maptype is not local
    if (widget.attrib.name != "Local") {
      var userMarker = new Marker(
        markerId: MarkerId("userMarker"),
        position: new LatLng(
            widget.attrib.center.latitude, widget.attrib.center.longitude),
      );
      setState(() {
        markers["userMarker"] = userMarker;
        destinationMarker = userMarker;
        destination = LatLng(
            widget.attrib.center.latitude, widget.attrib.center.longitude);
        _locationPicked = true;
      });
    } else {
      if (widget.mapState.userPosition != null) getTaxis();
      taxiTimer = Timer.periodic(Duration(seconds: refreshSec), (Timer t) {
        if (widget.mapState.userPosition != null) getTaxis();
      });
      // }
    }

    if (widget.mapState.polyLines.isNotEmpty) widget.mapState.clearRoute();
  }

  List<ToggleButtonItem> mapTypeList = <ToggleButtonItem>[
    ToggleButtonItem(
      name: "Normal",
      icon: Icon(
        Icons.map,
        color: Colors.amber,
      ),
    ),
    ToggleButtonItem(
      name: "Hybrid",
      icon: Icon(
        Icons.scanner_outlined,
        color: Colors.amber,
      ),
    ),
    ToggleButtonItem(
      name: "Terrain",
      icon: Icon(
        Icons.monochrome_photos,
        color: Colors.amber,
      ),
    ),
    ToggleButtonItem(
      name: "Satellite",
      icon: Icon(
        Icons.satellite,
        color: Colors.amber,
      ),
    ),
  ];

  List<ToggleButtonItem> vehicleTypeList = <ToggleButtonItem>[
    ToggleButtonItem(
      name: VehicleType.taxi,
      icon: Icon(
        Icons.local_taxi,
        color: Colors.amber,
      ),
    ),
    ToggleButtonItem(
      name: VehicleType.bike,
      icon: Icon(
        Icons.pedal_bike,
        color: Colors.amber,
      ),
    ),
    ToggleButtonItem(
      name: VehicleType.both,
      icon: Icon(
        Icons.bike_scooter,
        color: Colors.amber,
      ),
    ),
  ];

  getTaxis() async {
    var connected = await Utilities.isInternetWorking();
    if (!connected) return;

    var listOfTaxis = await getTaxisAPI(widget.mapState.userPosition.latitude,
        widget.mapState.userPosition.longitude);
    print('taxi refreshed');
    if (!isTaxiRequesting) markers.clear();
    if (_locationPicked == true) markers["userMarker"] = destinationMarker;
    if (listOfTaxis == null) return;

    if (vehicleType != VehicleType.both)
      listOfTaxis = listOfTaxis
          .where((element) => element.vehicleType == vehicleType)
          .toList();

    if (_activeTrip) {
      var res = listOfTaxis
          .where((element) => element.name == _activeTaxi.name)
          .toList();
      listOfTaxis = res;
    }

    for (var taxi in listOfTaxis) {
      var taxiMarker = new Marker(
        markerId: MarkerId(taxi.uniqueId + taxi.clientId.toString()),
        icon: taxi.vehicleType == 'taxi' ? taxiIcon : bikeIcon,
        rotation: taxi.course,
        // onTap: () {
        //   print("Listed ");
        //   _activeTrip ? showTaxiInfo(taxi) : requestTaxi(taxi);
        // },
        infoWindow: InfoWindow(
          title: taxi.name,
          onTap: isTaxiRequesting
              ? null
              : () async {
                  //location should be avialable for taxi request
                  if (widget.mapState.userPosition == null) {
                    Utilities.showInToast('Please turn on your location',
                        toastType: ToastType.ERROR);
                    return;
                  }

                  _activeTrip
                      ? showTaxiInfo(taxi)
                      : requestTaxi(taxi, listOfTaxis);
                },
        ),
        position: new LatLng(taxi.latitude, taxi.longitude),
      );
      if (this.mounted)
        setState(() {
          markers[taxi.uniqueId + taxi.clientId.toString()] = taxiMarker;
        });
    }
  }

  requestTaxi(Taxi taxi, List<Taxi> taxiList) async {
    //show input dialog
    TaxiRequest req = await showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (context) => TaxiRequestView(
          taxi: taxi,
          mapState: widget.mapState,
          locality: locality,
          arrayOfTaxi: taxiList),
    );

    if (req != null) {
      req.latitude = widget.mapState.userPosition.latitude.toString();
      req.longitude = widget.mapState.userPosition.longitude.toString();
      req.clientId = taxi.clientId.toString();

      req.appUserId = Provider.of<AuthState>(context, listen: false)
          .credentials
          .user
          .id
          .toString();

      var dist = calculateDistance(
              widget.mapState.userPosition.latitude,
              widget.mapState.userPosition.longitude,
              double.parse(req.destinationLatitude),
              double.parse(req.destinationLongitude),
              taxi.vehicleType)
          .toStringAsFixed(2);

      req.message = dist + ",$finalRate";
      // req.start = locality.isEmpty ? req.start : locality;
      setState(() {
        rate = "Distance: " + dist + " KM" + " , Rate: Rs. $finalRate";
      });

      setState(() {
        finalTaxi = taxi;
        finalTaxiRequest = req;
      });

      bool confirm = await showDialogForRateAndDistance(
          LatLng(double.parse(req.destinationLatitude),
              double.parse(req.destinationLongitude)),
          dist,
          finalRate.toString());

      if (confirm) {
        setState(() {
          isTaxiRequesting = true;
          disableMoveMarker = true;
        });

        requestTaxiAPI(taxi, taxiList);
        final MarkerId markerId = MarkerId("userMarker");

        final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(double.parse(finalTaxiRequest.destinationLatitude),
              double.parse(finalTaxiRequest.destinationLongitude)),
        );

        setState(() {
          markers["userMarker"] = marker;
        });
        // send request for direction
        widget.mapState.sendRequest(
            LatLng(double.parse(req.latitude), double.parse(req.longitude)),
            LatLng(double.parse(req.destinationLatitude),
                double.parse(req.destinationLongitude)));
      } else {
        Utilities.showInToast("Request Cancelled");
      }
    }
  }

  requestTaxiAPI(Taxi taxi, List<Taxi> listOfTaxis) {
    finalTaxiRequest.appUserId = Provider.of<AuthState>(context, listen: false)
        .credentials
        .user
        .id
        .toString();
    finalTaxiRequest.latitude =
        widget.mapState.userPosition.latitude.toString();
    finalTaxiRequest.longitude =
        widget.mapState.userPosition.longitude.toString();
    finalTaxiRequest.clientId = taxi.clientId.toString();
    log('Taxi request outside of loop ${taxi.clientId}');
    log('Taxi request api ko body ${jsonEncode(finalTaxiRequest)}');
    finalTaxi.requestAMultiple(finalTaxiRequest).then((value) {
      log('taxi request out of loop ko response $value');
      if (this.mounted) {
        taxiResponse = value;
        print('test in request $value');
        if (value == null) {
          Utilities.showInToast('Some error occoured',
              toastType: ToastType.ERROR);
          setState(() {
            isTaxiRequesting = false;
            widget.mapState.clearRoute();
          });
        } else {
          if (value.isAccepted == 1) {
            Utilities.showInToast('Request accepted!',
                toastType: ToastType.SUCCESS);
            print('test in request $value');
            //start trip
            print('starting trip');

            startTrip(finalTaxi);
            setState(() {
              isTaxiRequesting = false;
            });
          } else if (value.isRejected == 1) {
            // Utilities.showInToast('Request rejected!',
            //     toastType: ToastType.ERROR);
            setState(() {
              isTaxiRequesting = false;
              widget.mapState.clearRoute();
            });
          } else if (value.isCanceled == 1) {
            Utilities.showInToast('Request Canceled!',
                toastType: ToastType.INFO);
            setState(() {
              isTaxiRequesting = false;
              widget.mapState.clearRoute();
            });
          }
        }
        Provider.of<TaxiState>(context, listen: false)
            .setActiveTaxiResponse(value);
      }
    });

    for (Taxi taxiSec in listOfTaxis) {
      if (taxi.clientId != taxiSec.clientId) {
        finalTaxiRequest.clientId = taxiSec.clientId.toString();
        log('taxi requested inside of loop ${taxiSec.clientId}');
        finalTaxi.requestAMultiple(finalTaxiRequest).then((value) {
          if (this.mounted) {
            print('test in request outside $value');
            if (value == null) {
              Utilities.showInToast('Some error occoured',
                  toastType: ToastType.ERROR);
              setState(() {
                isTaxiRequesting = false;
                widget.mapState.clearRoute();
              });
            } else {
              if (value.isAccepted == 1) {
                Utilities.showInToast('Request accepted!',
                    toastType: ToastType.SUCCESS);

                //start trip
                print('starting trip');

                startTrip(finalTaxi);
                setState(() {
                  isTaxiRequesting = false;
                });
              } else if (value.isRejected == 1) {
                // Utilities.showInToast('Request rejected!',
                //     toastType: ToastType.ERROR);
                setState(() {
                  isTaxiRequesting = false;
                  widget.mapState.clearRoute();
                });
              } else if (value.isCanceled == 1) {
                Utilities.showInToast('Request Canceled!',
                    toastType: ToastType.INFO);
                setState(() {
                  isTaxiRequesting = false;
                  widget.mapState.clearRoute();
                });
              }
            }
            Provider.of<TaxiState>(context, listen: false)
                .setActiveTaxiResponse(value);
          }
        });
      }
    }
  }

  cancelAllRequest() async {
    await finalTaxi
        .cancelAllTaxiReqApi(taxiResponse.createdAt.toString() +
            '' +
            taxiResponse.appUserId.toString())
        .then((value) {
      if (value) {
        Utilities.showInToast("Request cancelled", toastType: ToastType.INFO);
      } else {
        Utilities.showInToast("Error cancelling request",
            toastType: ToastType.ERROR);
      }
    });
    widget.mapState.clearRoute();
    setState(() {
      isTaxiRequesting = false;
    });
  }

  cancelRequest() async {
    await finalTaxi.cancelTaxiReqApi().then((value) {
      if (value) {
        Utilities.showInToast("Request cancelled", toastType: ToastType.INFO);
      } else {
        Utilities.showInToast("Error cancelling request",
            toastType: ToastType.ERROR);
      }
    });
    widget.mapState.clearRoute();
    setState(() {
      isTaxiRequesting = false;
    });
  }

  showTaxiInfo(Taxi taxi) {
    AlertDialog alert = AlertDialog(
      title: Text(taxi.uniqueId),
      content: Text(taxi.vehicleType + '\n' + taxi.name),
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  startTrip(Taxi selectedTaxi) {
    setState(() {
      _activeTaxi = selectedTaxi;
      _activeTrip = true;
      _locationPicked = false;
    });
    getTaxis();
  }

  endTrip() async {
    print('ending');
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => TaxiRatingView(taxi: _activeTaxi),
    );
    setState(() {
      _activeTaxi = null;
      _activeTrip = false;
      isTaxiRequesting = false;
      widget.mapState.clearRoute();
    });

    getTaxis();
  }

  // calculate distance between two points
  double calculateDistance(lat1, lon1, lat2, lon2, String vehicleType) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var distance = 12742 * asin(sqrt(a));

    if (vehicleType == VehicleType.taxi) {
      var demoRate = distance.toInt() * Constants.taxiPerKm;
      finalRate = Constants.initialRateTaxi + demoRate;
    } else if (vehicleType == VehicleType.bike) {
      var demoRate = distance.toInt() * Constants.bikePerKm;
      finalRate = Constants.initialRateBike + demoRate;
    }
    distance = 12742 * asin(sqrt(a));

    return 12742 * asin(sqrt(a));
  }

  showDialogForRateAndDistance(
      LatLng destinationLatLng, String distance, String rate) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, false);
                  return false;
                },
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  getNotification();
                  Navigator.pop(context, true);
                  return true;
                },
              ),
            ],
            title: Text("Order Info"),
            content: Container(
              height: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total Distance is : $distance "),
                  Text("Total Rate is: Rs $rate"),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var userProvider = Provider.of<AuthState>(context, listen: false);

    Widget _mapView() {
      CameraPosition pos = CameraPosition(
          target: LatLng(
              widget.attrib.center.latitude, widget.attrib.center.longitude),
          zoom: midZoom);
      return GoogleMap(
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: true,
        myLocationEnabled: widget.mapState.userPosition != null,
        markers: Set<Marker>.of(markers.values),
        polylines: widget.mapState.polyLines,
        mapType: widget.mapState.mapType,
        initialCameraPosition: pos,
        onMapCreated: widget.mapState.onCreated,
        onCameraMove: (position) {
          if (markers.containsKey("userMarker") &&
              widget.attrib.name == "Local" &&
              !disableMoveMarker) {
            Marker marker = markers["userMarker"];
            Marker updatedMarker = marker.copyWith(
              positionParam: position.target,
            );
            setState(() {
              markers["userMarker"] = updatedMarker;
              destinationMarker = updatedMarker;
              destination = destinationMarker.position;
              print(destinationMarker.position.latitude.toString() +
                  "," +
                  destinationMarker.position.longitude.toString());
            });
          }
        },
        onTap: (position) {
          if (enablePathaoMode &&
              !_activeTrip &&
              widget.attrib.name == "Local") {
            final MarkerId markerId = MarkerId("userMarker");

            final Marker marker = Marker(
              markerId: markerId,
              position: position,
            );
            setState(() {
              markers["userMarker"] = marker;
              destinationMarker = marker;
              destination = position;
              disableMoveMarker = true;
              _locationPicked = true;
            });
          }
        },
      );
    }

    // widget to change the map type by toggle button
    Widget mapTypesToggleButton() {
      return Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: PopupMenuButton<ToggleButtonItem>(
              icon: Icon(
                Icons.map,
                color: Colors.amber,
              ),
              onSelected: (ToggleButtonItem value) {
                if (value.name == "Normal") {
                  widget.mapState.changeMapType(MapType.normal);
                } else if (value.name == "Hybrid") {
                  widget.mapState.changeMapType(MapType.hybrid);
                } else if (value.name == "Terrain") {
                  widget.mapState.changeMapType(MapType.terrain);
                } else if (value.name == "Satellite") {
                  widget.mapState.changeMapType(MapType.satellite);
                }
              },
              itemBuilder: (BuildContext context) {
                return mapTypeList.map((ToggleButtonItem mapTypeItem) {
                  return PopupMenuItem<ToggleButtonItem>(
                    value: mapTypeItem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        mapTypeItem.icon,
                        Text(
                          mapTypeItem.name,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              }),
        ),
      );
    }

    // widget to change the vehicle type by toggle button
    Widget vehicleTypeToggleButton() {
      return Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: PopupMenuButton<ToggleButtonItem>(
              icon: Icon(
                Icons.car_repair,
                color: Colors.amber,
              ),
              onSelected: (ToggleButtonItem value) {
                if (value.name == VehicleType.taxi) {
                  setState(() {
                    vehicleType = VehicleType.taxi;
                    getTaxis();
                  });
                } else if (value.name == VehicleType.bike) {
                  setState(() {
                    vehicleType = VehicleType.bike;
                    getTaxis();
                  });
                } else if (value.name == VehicleType.both) {
                  setState(() {
                    vehicleType = VehicleType.both;
                    getTaxis();
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return vehicleTypeList.map((ToggleButtonItem vehicleTypeItem) {
                  return PopupMenuItem<ToggleButtonItem>(
                    value: vehicleTypeItem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        vehicleTypeItem.icon,
                        Text(
                          vehicleTypeItem.name,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              }),
        ),
      );
    }

    Widget pickLocationContainer() {
      return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: enablePathaoMode
            ? Text("Click anywhere on map to select your destination")
            : SizedBox(),

        // TODO: uncomment below code if pathao api is done

        // : Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       MaterialButton(
        //         height: size.height * 0.05,
        //         minWidth: size.width,
        //         color: Colors.red[900],
        //         child: Row(
        //           children: [
        //             Icon(Icons.location_on),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             Text("Pick Location"),
        //           ],
        //         ),
        //         onPressed: () {
        //           setState(() {
        //             enablePathaoMode = true;
        //           });
        //         },
        //       ),
        //       // search text field
        //       MaterialButton(
        //         minWidth: size.width,
        //         height: size.height * 0.05,
        //         child: Row(
        //           children: [
        //             Icon(Icons.location_on),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             Text(destinationText),
        //           ],
        //         ),
        //         color: Colors.grey[100],
        //         onPressed: () async {
        //           final Suggestion result = await showSearch(
        //             context: context,
        //             delegate: AddressSearch(),
        //           );
        //           // This will change the text displayed in the TextField
        //           if (result != null) {
        //             final placeDetails = await PlaceApiProvider()
        //                 .getPlaceDetailFromId(result.placeId);
        //             setState(() {
        //               destinationText = result.description;
        //               destination = LatLng(
        //                   placeDetails.geometry.location.lat,
        //                   placeDetails.geometry.location.lng);
        //             });

        //             print(destination);

        //             if (this.mounted)
        //               setState(() {
        //                 destinationController.text = result.description;
        //                 final MarkerId markerId = MarkerId("userMarker");

        //                 final Marker marker = Marker(
        //                   markerId: markerId,
        //                   position: destination,
        //                 );
        //                 markers["userMarker"] = marker;
        //                 destinationMarker = marker;
        //                 _locationPicked = true;
        //                 // disableMoveMarker = true;
        //               });

        //             widget.mapState
        //                 .animateCameraToDesireLocation(destination);
        //           }
        //         },
        //       ),
        //     ],
        //   ),
      );
    }

    Widget appBarItems() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: BackButton(),
              ),
              mapTypesToggleButton(),
              vehicleTypeToggleButton(),
            ],
          ),
        ),
      );
    }

    Widget endTripContainer() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 300,
            height: 150,
            color: Color.fromARGB(255, 236, 235, 224),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(rate,
                      style: TextStyle(color: Color.fromARGB(255, 3, 3, 3))),
                ),
                MaterialButton(
                  color: Color.fromARGB(255, 97, 12, 90),
                  textColor: Colors.white,
                  onPressed: () {
                    endTrip();
                  },
                  child: Text('End trip'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget confirmDestinationForPathaoMode() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                height: size.height * 0.05,
                minWidth: size.width,
                color: Colors.green,
                child: Text("Confirm Destination"),
                onPressed: () async {
                  setState(() {
                    enablePathaoMode = false;
                  });
                  TaxiRequest taxiRequest = TaxiRequest();
                  taxiRequest.end = widget.attrib.name;
                  taxiRequest.latitude =
                      widget.mapState.userPosition.latitude.toString();
                  taxiRequest.longitude =
                      widget.mapState.userPosition.longitude.toString();
                  taxiRequest.message = "Urgent";
                  taxiRequest.destinationLatitude =
                      destinationMarker.position.latitude.toString();
                  taxiRequest.destinationLongitude =
                      destinationMarker.position.longitude.toString();
                  taxiRequest.appUserId =
                      userProvider.credentials.user.id.toString();

                  LatLng destinationLatLng = LatLng(
                      double.parse(taxiRequest.destinationLatitude),
                      double.parse(taxiRequest.destinationLongitude));
                  double destinationLat =
                      double.parse(taxiRequest.destinationLatitude);
                  double destinationLng =
                      double.parse(taxiRequest.destinationLongitude);
                  double initialLat = double.parse(taxiRequest.latitude);
                  double initialLng = double.parse(taxiRequest.longitude);

                  // dialog for rate and distance confirmation
                  bool confirm = await showDialogForRateAndDistance(
                      destinationLatLng,
                      calculateDistance(initialLat, initialLng, destinationLat,
                              destinationLng, VehicleType.taxi)
                          .toStringAsFixed(2),
                      finalRate.toString());

                  if (confirm) {
                    setState(() {
                      disableMoveMarker = true;
                    });
                    widget.mapState.sendRequest(
                        LatLng(initialLat, initialLng), destinationLatLng);
                  } else {
                    Utilities.showInToast("Request Cancelled");
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_sharp,
                ),
                label: 'Search',
              ),
            ],
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            selectedIconTheme: IconThemeData(size: 30.0),
            selectedItemColor: Color.fromARGB(255, 97, 12, 90),
            selectedLabelStyle: TextStyle(shadows: [])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: SizedBox(
        //   child: new FloatingActionButton(
        //     onPressed: () {
        //       setState(() {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => DestinationMapPage(
        //                 mapState: widget.mapState,
        //               ),
        //             ));
        //       });
        //     },
        //     backgroundColor: Color.fromARGB(255, 97, 12, 90),
        //     child: new Icon(Icons.bike_scooter),
        //   ),
        // ),
        floatingActionButton: !_activeTrip
            ? SizedBox()
            : FloatingActionButton(
                child: Icon(Icons.call),
                backgroundColor: Color.fromARGB(255, 97, 12, 90),
                onPressed: () {
                  launch('tel://' + _activeTaxi.phone);
                },
              ),
        body: widget.mapState.userPosition == null
            ? Container(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enable location services!",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  )
                ],
              ))
            : Stack(
                children: <Widget>[
                  _mapView(),
                  // confirm request for pathao
                  if (_locationPicked && !_activeTrip)
                    confirmDestinationForPathaoMode(),
                  // option to activate pick location
                  if (!_locationPicked &&
                      widget.attrib.name == "Local" &&
                      !_activeTrip)
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: isTaxiRequesting
                            ? TaxiRequestingView(
                                name: finalTaxi.name,
                                cancelRequest: cancelRequest,
                                requestAPI: requestTaxiAPI,
                              )
                            : pickLocationContainer()),
                  // back button, map toggle button, vehicle toggle button
                  if (!_activeTrip) appBarItems(),
                  // end trip button
                  if (_activeTrip) endTripContainer(),
                ],
              ),
      ),
    );
  }
}

class ToggleButtonItem {
  String name;
  Icon icon;

  ToggleButtonItem({
    this.name,
    this.icon,
  });
}
