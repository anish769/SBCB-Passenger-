import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/rental.dart';
import 'package:pokhara_app/view/pages/rental_car/rental_detail.dart';

class RentalItemList extends StatelessWidget {
  const RentalItemList({Key key, @required this.rental}) : super(key: key);

  final Rental rental;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RentalDetailPage(
              rental: rental,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            // color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Hero(
              tag: rental.vehiclePhoto,
              child: Container(
                height: size.height * 0.10,
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                      rental.vehiclePhoto,
                    ),
                    fit: BoxFit.contain,
                    onError: (exception, stackTrace) {
                      return Center(
                        child: Text("No Preview"),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Name: "),
                  Text(rental.vehicleName),
                ],
              ),
              Row(
                children: [
                  Text("Seat Capacity: "),
                  Text(rental.seatCapacity.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
