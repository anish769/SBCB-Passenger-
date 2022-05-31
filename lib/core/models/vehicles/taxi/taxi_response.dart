class TaxiResponse {
  int requestId;
  int appUserId;
  int clientId;
  String start;
  String end;
  String latitude;
  String longitude;
  String destinationLatitude;
  String destinationLongitude;
  String message;
  int isAccepted;
  int isRejected;
  int isCanceled;
  int isEnded;
  String createdAt;
  String updatedAt;

  TaxiResponse(
      {this.requestId,
      this.appUserId,
      this.clientId,
      this.start,
      this.end,
      this.latitude,
      this.longitude,
      this.destinationLatitude,
      this.destinationLongitude,
      this.message,
      this.isAccepted,
      this.isRejected,
      this.isCanceled,
      this.isEnded,
      this.createdAt,
      this.updatedAt});

  TaxiResponse.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    appUserId = int.parse(json['app_user_id'].toString());
    clientId = json['client_id'];
    start = json['start'];
    end = json['end'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    destinationLatitude = json['dest_latitude'];
    destinationLongitude = json['dest_longitude'];
    message = json['message'];
    isAccepted = json['is_accepted'];
    isRejected = json['is_rejected'];
    isCanceled = json['is_canceled'];
    isEnded = json['is_ended'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['app_user_id'] = this.appUserId;
    data['client_id'] = this.clientId;
    data['start'] = this.start;
    data['end'] = this.end;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['dest_latitude'] = this.destinationLatitude;
    data['dest_longitude'] = this.destinationLongitude;
    data['message'] = this.message;
    data['is_accepted'] = this.isAccepted;
    data['is_rejected'] = this.isRejected;
    data['is_canceled'] = this.isCanceled;
    data['is_ended'] = this.isEnded;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
