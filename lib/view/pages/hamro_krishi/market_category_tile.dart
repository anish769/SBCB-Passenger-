import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/hamro_agro_market/market_item.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/market_individual_item.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/market_item_list.dart';
import 'package:pokhara_app/view/pages/hamro_krishi/market_see_more.dart';

class MarketCategoryTile extends StatelessWidget {
  const MarketCategoryTile({
    @required this.cat,
    @required this.marketItemKeyList,
  });

  final String cat;
  final List<MarketItem> marketItemKeyList;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        color: Colors.grey[350],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          height: size.height * 0.32,
          // width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            // color: Colors.black45,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cat,
                      overflow: TextOverflow.fade,
                      maxLines: null,
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 75,
                    height: 26,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MarketSeeMore(
                                marketItemList: marketItemKeyList,
                                category: cat)));
                      },
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        "See More >",
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MarketItemList(item: marketItemKeyList[index]);
                  },
                  itemCount: marketItemKeyList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
