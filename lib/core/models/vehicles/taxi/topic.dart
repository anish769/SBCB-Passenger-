import 'dart:convert';

import 'package:pokhara_app/utils/constants.dart';

import '../../../../utils/api_urls.dart';
import '../../../../utils/utilities.dart';
import 'package:http/http.dart' as http;

class NotificationAPI {
  String messageId;

  NotificationAPI({this.messageId});

  NotificationAPI.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.messageId;
    return data;
  }
}

Future<NotificationAPI> getNotification() async {
  print(Constants.token);

  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.notificationUrl),
      headers: header,
    );
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);

    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        final categs = await data.map<NotificationAPI>((json) {
          return NotificationAPI.fromJson(json);
        }).toList();
        return categs;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}
