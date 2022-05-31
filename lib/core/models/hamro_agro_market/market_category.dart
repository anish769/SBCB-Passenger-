import 'dart:convert';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:http/http.dart' as http;

class MarketCategory {
  int id;
  String nameNep;
  String nameEng;
  String createdAt;
  String updatedAt;

  MarketCategory(
      {this.id, this.nameNep, this.nameEng, this.createdAt, this.updatedAt});

  MarketCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameNep = json['name_nep'];
    nameEng = json['name_eng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_nep'] = this.nameNep;
    data['name_eng'] = this.nameEng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

Future<List<MarketCategory>> getMarketCategoriesAPI() async {
  print(Constants.token);

  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.marketCategoriesUrl),
      headers: header,
    );
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);

    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        final categs = await data.map<MarketCategory>((json) {
          return MarketCategory.fromJson(json);
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
    Utilities.showInToast('Failed to get categories!',
        toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}
