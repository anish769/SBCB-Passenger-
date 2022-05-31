import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/ui_strings.dart';
import 'package:pokhara_app/utils/utilities.dart';

class Ad {
  int id;
  String title;
  String keyword;
  String description;
  double latitude;
  double longitude;
  String fileUrl;
  String contactNum;
  String webUrl;
  String createdAt;
  String updatedAt;

  Ad(
      {this.id,
      this.title,
      this.keyword,
      this.description,
      this.latitude,
      this.longitude,
      this.fileUrl,
      this.createdAt,
      this.updatedAt});

  Ad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    keyword = json['keyword'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    contactNum = json['contact_number'];
    webUrl = json['web_url'];

    ///Making sure url is complete and can be launched by [URL LAUNCHER]
    if (webUrl != null) {
      if (!webUrl.contains('http')) webUrl = 'http://' + webUrl;
    }
    longitude = json['longitude'];
    fileUrl = Urls.imgDwnPrefix + json['file_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['keyword'] = this.keyword;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['file_url'] = this.fileUrl;
    data['contact_number'] = this.contactNum;
    data['web_url'] = this.webUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

Future<List<Ad>> getAdsAPI() async {
  print(Constants.token);

  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.adsList),
      headers: header,
    );
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);

    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        final List<Ad> ads = await data.map<Ad>((json) {
          return Ad.fromJson(json);
        }).toList();
        ads.forEach((e) {
          print(e.fileUrl);
        });

        return ads;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    Utilities.showInToast(UIStrings.errorAds, toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}

Future<List<Ad>> searchAdsAPI(String keyword) async {
  print(Constants.token);

  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.searchAd + keyword),
      headers: header,
    );
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);
    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        var ads = await data.map<Ad>((json) {
          return Ad.fromJson(json);
        }).toList();
        return ads;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    Utilities.showInToast(UIStrings.errorTaxi, toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}
