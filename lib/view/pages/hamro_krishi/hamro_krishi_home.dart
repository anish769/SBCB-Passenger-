import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/hamro_agro_market/market_item.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import "package:collection/collection.dart";

import 'market_category_tile.dart';

class HamroKrishiHomePage extends StatefulWidget {
  @override
  _HamroKrishiHomePageState createState() => _HamroKrishiHomePageState();
}

class _HamroKrishiHomePageState extends State<HamroKrishiHomePage> {
  List<MarketItem> marketItemList;

  List<String> categoryNameList = <String>[];

  Map<dynamic, List<MarketItem>> groupedList;

  @override
  void initState() {
    getMarketItemAPI().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          setState(() {
            marketItemList = value;
            groupedList = groupBy(marketItemList, (obj) => obj.categoryEnglish);

            for (var i in groupedList.keys) {
              print(i);
              categoryNameList.add(i);
              // var dd = groupedList[i];
              print(groupedList[i]);
            }
          });
        } else {
          setState(() {
            marketItemList = [];
            groupedList = {};
          });
        }
      } else {
        setState(() {
          marketItemList = [];
          groupedList = {};
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text(UIStrings.sbcbKrishi),
      ),
      body: groupedList != null
          ? groupedList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupedList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = groupedList.keys.elementAt(index);
                    return MarketCategoryTile(
                        cat: key, marketItemKeyList: groupedList[key]);
                  })
              : Center(
                  child: Text("No data to show"),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      // body: FutureBuilder(
      //   future: getMarketCategoriesAPI(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.hasData) {
      //       List<MarketCategory> categories = snapshot.data;
      //       return ListView.builder(
      //           itemCount: categories.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             return MarketCategoryTile(cat: categories[index]);
      //           });
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
