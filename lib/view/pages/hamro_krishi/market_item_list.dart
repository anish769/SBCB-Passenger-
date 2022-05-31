import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/hamro_agro_market/market_item.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/market_individual_item.dart';

class MarketItemList extends StatelessWidget {
  final MarketItem item;

  const MarketItemList({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MarketIndividualItem(
              item: item,
            ),
          ));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.black45,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Hero(
                tag: item.imageUrl,
                child: Container(
                  width: size.width * 0.3,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            item.imageUrl,
                          ))),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nameEng),
                Text(
                  '> Rs ${item.amount} / ${item.unit}',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
