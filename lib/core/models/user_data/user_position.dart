class UserPosition {
  int id;
  String protocol;
  int appUserId;
  String servertime;
  String devicetime;
  String fixtime;
  int valid;
  double latitude;
  double longitude;
  int altitude;
  double speed;
  double course;
  String address;
  String attributes;
  int accuracy;
  String network;
  String createdAt;
  String updatedAt;

  UserPosition(
      {this.id,
      this.protocol,
      this.appUserId,
      this.servertime,
      this.devicetime,
      this.fixtime,
      this.valid,
      this.latitude,
      this.longitude,
      this.altitude,
      this.speed,
      this.course,
      this.address,
      this.attributes,
      this.accuracy,
      this.network,
      this.createdAt,
      this.updatedAt});

  UserPosition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    protocol = json['protocol'];
    appUserId = json['app_user_id'];
    servertime = json['servertime'];
    devicetime = json['devicetime'];
    fixtime = json['fixtime'];
    valid = json['valid'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    altitude = json['altitude'];
    speed = json['speed'].toDouble();
    course = json['course'].toDouble();
    address = json['address'];
    attributes = json['attributes'];
    accuracy = json['accuracy'];
    network = json['network'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['protocol'] = this.protocol;
    data['app_user_id'] = this.appUserId;
    data['servertime'] = this.servertime;
    data['devicetime'] = this.devicetime;
    data['fixtime'] = this.fixtime;
    data['valid'] = this.valid;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['altitude'] = this.altitude;
    data['speed'] = this.speed;
    data['course'] = this.course;
    data['address'] = this.address;
    data['attributes'] = this.attributes;
    data['accuracy'] = this.accuracy;
    data['network'] = this.network;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
