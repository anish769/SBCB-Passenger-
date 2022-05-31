import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';

class CircuitInfo {
  int id;
  int startingStationId;
  int endingStationId;
  int estimatedTime;
  int estimatedPrice;
  int estimatedKilometer;

  CircuitInfo(
      {this.id,
      this.startingStationId,
      this.endingStationId,
      this.estimatedTime,
      this.estimatedPrice,
      this.estimatedKilometer});

  CircuitInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startingStationId = json['starting_station_id'];
    endingStationId = json['ending_station_id'];
    estimatedTime = json['estimated_time'];
    estimatedPrice = json['estimated_price'];
    estimatedKilometer = json['estimated_kilometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['starting_station_id'] = this.startingStationId;
    data['ending_station_id'] = this.endingStationId;
    data['estimated_time'] = this.estimatedTime;
    data['estimated_price'] = this.estimatedPrice;
    data['estimated_kilometer'] = this.estimatedKilometer;
    return data;
  }
}

Future<CircuitInfo> getCircuitInfo(int from, int to) async {
  var startId = from.toString();
  var endId = to.toString();
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  var url =
      'http://202.52.240.148:8092/sbcb/api/circuits?starting_station_id=$startId&ending_station_id=$endId';
  try {
    final response = await http.get(Uri.parse(url), headers: header);
    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"];
        if (data == null) return CircuitInfo();
        var cir = CircuitInfo.fromJson(data);
        return cir;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    Utilities.showInToast('Failed to get circuit', toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}
