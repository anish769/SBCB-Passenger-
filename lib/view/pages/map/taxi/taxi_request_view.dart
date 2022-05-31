import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong/latlong.dart';
import 'package:pokhara_app/core/models/circuit_info.dart';
import 'package:pokhara_app/core/models/station.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi_request.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi.dart';
import 'package:pokhara_app/core/services/map_service.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:pokhara_app/core/models/google_place/google_place_autocomplete.dart';
import 'package:pokhara_app/view/pages/map/address_search.dart';
import 'package:pokhara_app/view/pages/map/taxi/destination_map.dart';

import '../../../../core/models/vehicles/taxi/topic.dart';

class TaxiRequestView extends StatefulWidget {
  final Taxi taxi;
  final List<Taxi> arrayOfTaxi;
  final MapState mapState;
  final String locality;

  const TaxiRequestView(
      {Key key, this.taxi, this.mapState, this.locality, this.arrayOfTaxi})
      : super(key: key);
  @override
  _TaxiRequestViewState createState() => _TaxiRequestViewState();
}

class _TaxiRequestViewState extends State<TaxiRequestView> {
  String rating;

  final _formKey = GlobalKey<FormState>();
  List<Station> fromList, toList;
  Station from, to;
  var groupValue = "";
  bool requestEnabled = false;

  String finalDestination = "";
  String selectDestination = "Select Destination";
  String chooseDestination = "Choose On Map";
  String remarks = "";

  LatLng startPosition;
  LatLng destinationPosition;

  TextEditingController _sourceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      requestEnabled = true;
      groupValue = "LOCAL";
      _sourceController.text = widget.locality;
    });
    // widget.taxi.getTaxiRatingAPI().then((value) {
    //   if (this.mounted)
    //     setState(() {
    //       rating = value;
    //     });
    // });
    getStations().then((val) {
      if (this.mounted)
        setState(() {
          fromList = val;
          from = fromList.first;
          toList = val.reversed.toList();
          to = toList.first;
        });
    });
  }

  determineStreet(Position pos) async {
    setState(() {
      destinationPosition = LatLng(pos.latitude, pos.longitude);
    });
    try {
      print("LatLng: " +
          pos.latitude.toString() +
          "," +
          pos.longitude.toString());
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      setState(() {
        destinationPosition = LatLng(pos.latitude, pos.longitude);
        chooseDestination = placemarks[0].street;
        finalDestination = chooseDestination;
      });

      print("Place: " + placemarks[0].street);
    } catch (e) {
      Utilities.showInToast(
          "No address information found for supplied coordinates! Please manually write street address",
          toastType: ToastType.INFO);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    Utilities.showInToast(response.errorMessage, toastType: ToastType.ERROR);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Widget functional() {
    //   return Padding(
    //     padding: const EdgeInsets.all(7.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         //rating
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Text(
    //               'Rating',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //             rating == null
    //                 ? Container(
    //                     width: 20,
    //                     height: 20,
    //                     child: CircularProgressIndicator())
    //                 : Row(
    //                     children: [
    //                       if (rating != 'N/A')
    //                         Row(
    //                           children: List.generate(
    //                               int.parse(rating.split('.').first), (i) {
    //                             return Icon(Icons.star);
    //                           }),
    //                         ),
    //                       Text(' ' + rating),
    //                     ],
    //                   )
    //           ],
    //         ),
    //         SizedBox(
    //           width: 55,
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget sourceInput() {
      return TextField(
        controller: _sourceController,
        decoration: InputDecoration(
          label: Text("Enter Source"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }

    Widget destinationInput() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          child: MaterialButton(
            minWidth: size.width,
            child: Text(selectDestination),
            color: Colors.grey[100],
            onPressed: () async {
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(),
              );
              if (result != null) {
                final placeDetails = await PlaceApiProvider()
                    .getPlaceDetailFromId(result.placeId);
                if (this.mounted)
                  setState(() {
                    selectDestination = result.description;
                    finalDestination = result.description;
                    destinationPosition = LatLng(
                        placeDetails.geometry.location.lat,
                        placeDetails.geometry.location.lng);
                  });
              }
            },
          ),
        ),
      );
    }

    Widget destinationFromMap() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          child: MaterialButton(
            minWidth: size.width,
            child: Text(chooseDestination),
            color: Colors.grey[100],
            onPressed: () async {
              var result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DestinationMapPage(
                        mapState: widget.mapState,
                      )));
              if (result != null) {
                determineStreet(result[0]);
                setState(() {
                  remarks = result[1];
                  if (chooseDestination == "Choose On Map") {
                    chooseDestination = remarks;
                  }
                });
              }
            },
          ),
        ),
      );
    }

    Widget fromDropDown() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('From'),
            DropdownButton<Station>(
                value: from != null ? from : fromList.first,
                items: fromList.map((e) {
                  return DropdownMenuItem<Station>(
                      value: e, child: Text(e.name.toUpperCase()));
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    requestEnabled = false;
                    from = e;
                  });
                })
          ],
        ),
      );
    }

    Widget toDropDown() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('To'),
            DropdownButton<Station>(
                value: to != null ? to : toList.first,
                items: toList.map((e) {
                  return DropdownMenuItem<Station>(
                      value: e, child: Text(e.name.toUpperCase()));
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    requestEnabled = false;

                    to = e;
                  });
                })
          ],
        ),
      );
    }

    Widget actionButtons() {
      return Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {
                // getNotification();
                if (!requestEnabled) return;
                if (!_formKey.currentState.validate()) return;
                if (_sourceController.text.isEmpty) return;
                var req = TaxiRequest(
                  end: groupValue == "LOCAL"
                      ? finalDestination.isEmpty
                          ? remarks
                          : finalDestination
                      : to.name,
                  destinationLatitude: destinationPosition.latitude.toString(),
                  destinationLongitude:
                      destinationPosition.longitude.toString(),
                  message: 'Normal',
                  remarks: remarks,
                  start: _sourceController.text,
                );
                print('taxi request request params $req');
                print(finalDestination);
                print(destinationPosition.latitude.toString());
                print(destinationPosition.longitude.toString());
                print(remarks);
                print(_sourceController);
                Navigator.pop(context, req);
              },
              color: Color.fromARGB(255, 71, 13, 206),
              child: Text('Request'),
              textColor: Colors.white,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () => Navigator.pop(context),
              color: Color.fromARGB(255, 168, 15, 43),
              child: Text('Cancel'),
              textColor: Colors.white,
            ),
          ),
        ],
      );
    }

    Widget header() {
      return Container(
        height: 40,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  Icon(
                  //     widget.taxi.vehicleType == VehicleType.taxi
                  //         ? Icons.local_taxi
                  //         : Icons.directions_bike,
                  //     color: Colors.white,
                  //   ),
                  Text(
                    'Create a new request ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget locationInput() {
      return Column(
        children: fromList == null
            ? [LinearProgressIndicator()]
            : [
                if (groupValue == 'LOCAL')
                  Column(
                    children: [
                      // destinationInput(),
                      destinationFromMap(),
                      Text(remarks),
                    ],
                  ),
                if (groupValue == 'ROUTE')
                  Column(
                    children: [
                      fromDropDown(),
                      toDropDown(),
                    ],
                  ),
                if (to != null && from != null && groupValue != "LOCAL")
                  FutureBuilder<CircuitInfo>(
                    future: getCircuitInfo(from.id, to.id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      requestEnabled = false;
                      if (snapshot.hasData) {
                        CircuitInfo data = snapshot.data;
                        if (data != null && data.id != null) {
                          requestEnabled = true;
                          return Column(
                            children: [
                              ListTile(
                                  leading: Icon(Icons.money),
                                  title: Text(
                                      'Rs ' + data.estimatedPrice.toString()),
                                  subtitle: Text('ESTD rate')),
                              ListTile(
                                  leading: Icon(Icons.swap_calls),
                                  title: Text(
                                      data.estimatedKilometer.toString() +
                                          ' km'),
                                  subtitle: Text('ESTD distance')),
                              ListTile(
                                  leading: Icon(Icons.watch_later_outlined),
                                  title: Text(
                                      data.estimatedKilometer.toString() +
                                          ' hour'),
                                  subtitle: Text('ESTD Arrival time')),
                            ],
                          );
                        } else
                          return Text('No data');
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
              ],
      );
    }

    onvalchanged(Object val) {
      setState(() {
        groupValue = val;
        switch (val) {
          case "LOCAL":
            print('Local mode');
            break;
          case "ROUTE":
            print('Long route mode');

            break;
        }
      });
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Transform.translate(
          //   offset: Offset(0, 22),
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: NetworkImage(widget.taxi.driverImage),
          //   ),
          // ),
          Dialog(
              insetAnimationDuration: Duration(seconds: 3),
              insetAnimationCurve: Curves.bounceIn,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            header(),
                            Divider(),
                            //functional(),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 'LOCAL',
                                  groupValue: groupValue,
                                  onChanged: onvalchanged,
                                ),
                                new Text(
                                  'Local',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value: 'ROUTE',
                                  groupValue: groupValue,
                                  onChanged: onvalchanged,
                                ),
                                new Text(
                                  'Long-Route',
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.locality.isEmpty)
                              sourceInput()
                            else
                              Text("Start: " + widget.locality),
                            locationInput(),
                            // destinationInput(),
                            actionButtons()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
