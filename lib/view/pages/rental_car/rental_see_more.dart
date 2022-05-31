import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/rental.dart';
import 'package:pokhara_app/view/pages/rental_car/rental_item_list.dart';

class RentalSeeMore extends StatelessWidget {
  RentalSeeMore({Key key, @required this.company, @required this.rentalList})
      : super(key: key);

  String company;
  List<Rental> rentalList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company),
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
            return RentalItemList(rental: rentalList[index]);
          },
          itemCount: rentalList.length,
        ),
      ),
    );
  }
}
