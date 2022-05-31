import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';

class Station {
  int id;
  String name;
  String nameNp;

  Station({this.id, this.name, this.nameNp});

  Station.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameNp = json['name_np'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_np'] = this.nameNp;
    return data;
  }
}

Future<List<Station>> getStations() async {
  try {
    var header = {
      'Authorization': 'Bearer ' + Constants.token,
      'Accept': 'application/json'
    };
    final response = await http.get(
        Uri.parse('http://117.121.237.226:86/sbcb/api/stations'),
        headers: header);
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);

    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        print(data.first);
        final stations = await data.map<Station>((json) {
          return Station.fromJson(json);
        }).toList();
        return stations;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    Utilities.showInToast('Failed to get Stations', toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}
