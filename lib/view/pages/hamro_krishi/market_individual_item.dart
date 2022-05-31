import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/hamro_agro_market/market_item.dart';

class MarketIndividualItem extends StatelessWidget {
  const MarketIndividualItem({Key key, this.item}) : super(key: key);
  final MarketItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.nameEng),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   label: Row(
      //     children: [
      //       Icon(Icons.shopping_basket),
      //       Text('   Add to Basket'),
      //     ],
      //   ),
      //   onPressed: () {
      //     Utilities.showInToast('To be implimented', toastType: ToastType.INFO);
      //   },
      // ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                  tag: item.imageUrl,
                  child:
                      Card(elevation: 12, child: Image.network(item.imageUrl))),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.description))
            ],
          ),
        ),
      ),
    );
  }
}
