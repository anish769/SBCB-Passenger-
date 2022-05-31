import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/hamro_agro_market/market_item.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/market_item_list.dart';

class MarketSeeMore extends StatelessWidget {
  MarketSeeMore(
      {Key key, @required this.marketItemList, @required this.category})
      : super(key: key);

  final List<MarketItem> marketItemList;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.75 / 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0),
          itemBuilder: (context, index) {
            return MarketItemList(
              item: marketItemList[index],
            );
          },
          itemCount: marketItemList.length,
        ),
      ),
    );
  }
}
