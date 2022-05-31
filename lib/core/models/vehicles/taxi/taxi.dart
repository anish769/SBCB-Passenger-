import 'dart:convert';
import 'dart:developer';

import 'package:pokhara_app/core/models/vehicles/taxi/taxi_request.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi_response.dart';
import 'package:pokhara_app/core/models/vehicles/vehicle.dart';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';

import 'package:http/http.dart' as http;

class Taxi extends Vehicle {
  int deviceId;
  String address;

  String devicetime;
  int altitude;
  int clientId;
  String phone;
  String driverImage;

  // Taxi(
  //     {this.uniqueid,
  //     this.deviceId,
  //     this.address,
  //     this.course,
  //     this.speed,
  //     this.attributes,
  //     this.devicetime,
  //     this.valid,
  //     this.serverTime,
  //     this.latitude,
  //     this.altitude,
  //     this.longitude,
  //     this.uniqueId,
  //     this.clientId,
  //     this.phone,
  //     this.distance});

  Taxi.fromJson(Map<String, dynamic> json) {
    uniqueId = json['uniqueid'];
    print(uniqueId);
    name = json['uniqueId']; // name is uniqueID
    driverImage = json['image'] != null
        ? (Urls.driverPicUrl + json['image'])
        : json["image"];
    deviceId = json['device_id'];
    address = json['address'];
    course = json['course'].toDouble();
    speed = json['speed'].toDouble();
    attributes = json['attributes'];
    devicetime = json['devicetime'];
    valid = json['valid'];
    servertime = json['serverTime'];
    latitude = json['latitude'];
    altitude = json['altitude'].toInt();
    longitude = json['longitude'];
    uniqueId = json['uniqueId'];
    clientId = json['client_id'];
    phone = json['phone'];
    distance = json['distance'].toDouble();
    vehicleType = json['vehicle_type'];
  }

  get appUserId => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniqueid'] = this.uniqueId;
    data['device_id'] = this.deviceId;
    data['image'] = this.driverImage;
    data['address'] = this.address;
    data['course'] = this.course;
    data['speed'] = this.speed;
    data['attributes'] = this.attributes;
    data['devicetime'] = this.devicetime;
    data['valid'] = this.valid;
    data['serverTime'] = this.servertime;
    data['latitude'] = this.latitude;
    data['altitude'] = this.altitude;
    data['longitude'] = this.longitude;
    data['uniqueId'] = this.uniqueId;
    data['client_id'] = this.clientId;
    data['phone'] = this.phone;
    data['distance'] = this.distance;
    return data;
  }

  Future<String> getTaxiRatingAPI() async {
    String rating = 'N/A';
    try {
      final response = await http.post(
        Uri.parse(Urls.taxiRatingDisplay),
        headers: {
          'Authorization': 'Bearer ' + Constants.token,
          'Accept': 'application/json'
        },
        body: {'client_id': this.clientId.toString()},
      );
      if (Utilities.handleStatus(response.statusCode)) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (mapResponse["error"]) {
          rating = mapResponse['data'].toString();
        }
      }
      return rating;
    } catch (e) {
      print(e.toString());
      return rating;
    }
  }

  Future<TaxiResponse> requestAMultiple(TaxiRequest request) async {
    print('Req api hit');
    var header = {
      'Authorization': 'Bearer ' + Constants.token,
      'Accept': 'application/json'
    };
    print(request.toJson());
    log('Header value is $header');
    TaxiResponse txResp;
    try {
      final response = await http.post(Uri.parse(Urls.taxiRequest),
          headers: {
            'Authorization': 'Bearer ' + Constants.token,
            'Accept': 'application/json'
          },
          body: request.toJson());
      if (Utilities.handleStatus(response.statusCode)) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        log('api response  ${response.body}');
        txResp = TaxiResponse.fromJson(mapResponse['data']);
        print(mapResponse);
        return txResp;
      } else {
        return txResp;
      }
    } catch (ex) {
      log('Error in taxi request api');
      print(ex.toString());
      return txResp;
    }
  }

  Future<bool> cancelTaxiReqApi() async {
    try {
      final response = await http.post(
        Uri.parse(Urls.taxiAllCancelRequest),
        headers: {
          'Authorization': 'Bearer ' + Constants.token,
          'Accept': 'application/json'
        },
        body: {'client_id': this.clientId.toString()},
      );
      if (Utilities.handleStatus(response.statusCode)) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (!mapResponse["error"]) {
          print(mapResponse);
          return true;
        }
      }
      print(response);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> cancelAllTaxiReqApi(String uniqueId) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.taxiCancelRequest),
        headers: {
          'Authorization': 'Bearer ' + Constants.token,
          'Accept': 'application/json'
        },
        body: {'client_id': this.clientId.toString(), 'unique_id': uniqueId},
      );
      if (Utilities.handleStatus(response.statusCode)) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (!mapResponse["error"]) {
          print(mapResponse);
          return true;
        }
      }
      print(response);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

Future<TaxiResponse> requestPathaoAPI(TaxiRequest request) async {
  print('Successful');
  print(request.toJson());
  TaxiResponse txResp;

  try {
    final response = await http.post(Uri.parse(Urls.taxiPathaoRequest),
        headers: {
          'Authorization': 'Bearer ' + Constants.token,
          'Accept': 'application/json'
        },
        body: request.toPathaoJson());
    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      txResp = TaxiResponse.fromJson(mapResponse['data']);

      print(mapResponse);
    }

    return txResp;
  } catch (ex) {
    print(ex.toString());
    return txResp;
  }
}

//static methods
Future<List<Taxi>> getTaxisAPI(double lat, double long) async {
  print(Constants.token);

  var body = {
    'latitude': lat.toString(),
    'longitude': long.toString(),
    'email': Constants.accessEmail
  };
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  // try {
  final response =
      await http.post(Uri.parse(Urls.taxiList), headers: header, body: body);
  // final response2 = await http.post(Urls.checkSubscribe, headers: header);

  // print(response2.body);

  if (Utilities.handleStatus(response.statusCode)) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (!mapResponse["error"]) {
      final data = mapResponse["data"].cast<Map<String, dynamic>>();
      final taxis = await data.map<Taxi>((json) {
        return Taxi.fromJson(json);
      }).toList();
      return taxis;
    } else {
      print(response.body);
      return null;
    }
  } else {
    print(response.body);

    return null;
  }
  // } catch (e) {
  //   Utilities.showInToast(UIStrings.errorTaxi, toastType: ToastType.ERROR);
  //   print(e.toString());
  //   return null;
  // }
}

Future<bool> endTripAPI(
    int requestId, int rating, String distance, String amount,
    {String comment = ''}) async {
  var body = {
    'request_id': requestId.toString(),
    'rating': rating.toString(),
    'total_amount': amount,
    'total_distance': distance,
    if (comment.isNotEmpty) 'review': comment
  };
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response =
        await http.post(Uri.parse(Urls.endTrip), headers: header, body: body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      return !mapResponse["error"];
    } else {
      print(response.body);

      return false;
    }
  } catch (e) {
    Utilities.showInToast(UIStrings.errorTaxi, toastType: ToastType.ERROR);
    print(e.toString());
    return false;
  }
}
