// import 'package:flutter/foundation.dart';

class TaxiRequest {
  String clientId;
  String start;
  String end;
  String latitude;
  String longitude;
  String message;
  String remarks;
  String destinationLatitude;
  String destinationLongitude;
  String appUserId;

  TaxiRequest({
    this.clientId,
    this.start,
    this.end,
    this.latitude,
    this.longitude,
    this.message,
    this.remarks,
    this.destinationLatitude,
    this.destinationLongitude,
    this.appUserId,
  });

  TaxiRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    start = json['start'];
    end = json['end'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    destinationLatitude = json['dest_latitude'];
    destinationLongitude = json['dest_longitude'];
    message = json['message'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['start'] = this.start;
    data['app_user_id'] = this.appUserId.toString();
    data['end'] = this.end;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['dest_latitude'] = this.destinationLatitude;
    data['dest_longitude'] = this.destinationLongitude;
    data['message'] = this.message;
    data['remarks'] = this.remarks = 'hey';
    return data;
  }

  Map<String, dynamic> toPathaoJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['start'] = this.start;
    data['end'] = this.end;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['message'] = this.message;
    data['remarks'] = this.remarks;
    data['dest_latitude'] = this.destinationLatitude;
    data['dest_longitude'] = this.destinationLongitude;
    data['app_user_id'] = this.appUserId;

    return data;
  }
}
