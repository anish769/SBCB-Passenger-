import 'dart:convert';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:http/http.dart' as http;

class MarketItem {
  int id;
  String nameNep;
  String nameEng;
  String description;
  String imageUrl;
  String unit;
  String minOrderQuantity;
  int amount;
  String expiredAt;
  String categoryNepali;
  String categoryEnglish;
  String createdAt;
  String updatedAt;

  MarketItem(
      {this.id,
      this.nameNep,
      this.nameEng,
      this.description,
      this.imageUrl,
      this.unit,
      this.minOrderQuantity,
      this.amount,
      this.expiredAt,
      this.categoryNepali,
      this.categoryEnglish,
      this.createdAt,
      this.updatedAt});

  MarketItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameNep = json['name_nep'];
    nameEng = json['name_eng'];
    description = json['description'];
    imageUrl = Urls.imgDwnPrefix + json['image_url'];
    unit = json['unit'];
    minOrderQuantity = json['min_order_quantity'];
    amount = json['amount'];
    expiredAt = json['expired_at'];
    categoryNepali = json['category_nepali'];
    categoryEnglish = json['category_english'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_nep'] = this.nameNep;
    data['name_eng'] = this.nameEng;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['unit'] = this.unit;
    data['min_order_quantity'] = this.minOrderQuantity;
    data['amount'] = this.amount;
    data['expired_at'] = this.expiredAt;
    data['category_nepali'] = this.categoryNepali;
    data['category_english'] = this.categoryEnglish;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

Future<List<MarketItem>> getMarketItemAPI() async {
  print(Constants.token);

  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.marketItems),
      headers: header,
    );
    // final response2 = await http.post(Urls.checkSubscribe, headers: header);

    // print(response2.body);

    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        if (data.isEmpty) {
          return <MarketItem>[];
        }
        final items = await data.map<MarketItem>((json) {
          return MarketItem.fromJson(json);
        }).toList();
        return items;
      } else {
        print(response.body);
        return null;
      }
    } else {
      print(response.body);

      return null;
    }
  } catch (e) {
    Utilities.showInToast('Failed to get items!', toastType: ToastType.ERROR);
    print(e.toString());
    return null;
  }
}
