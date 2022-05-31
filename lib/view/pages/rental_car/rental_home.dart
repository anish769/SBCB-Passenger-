import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/rental.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import "package:collection/collection.dart";
import 'package:pokhara_app/view/pages/rental_car/rental_item_list.dart';
import 'package:pokhara_app/view/pages/rental_car/rental_see_more.dart';

class RentalCarHomePage extends StatefulWidget {
  @override
  _RentalCarHomePageState createState() => _RentalCarHomePageState();
}

class _RentalCarHomePageState extends State<RentalCarHomePage> {
  String nextPageUrl;

  List<Rental> rentalList;
  List<String> companyNameList = <String>[];

  Map<dynamic, List<Rental>> groupedList;

  @override
  void initState() {
    super.initState();

    getRental().then((value) async {
      if (value != null) {
        if (value.isNotEmpty) {
          setState(() {
            rentalList = value;
            groupedList = groupBy(rentalList, (obj) => obj.companyName);

            for (var i in groupedList.keys) {
              print(i);
              companyNameList.add(i);
              // var dd = groupedList[i];
              print(groupedList[i]);
            }
          });
        } else {
          setState(() {
            rentalList = [];
            groupedList = {};
          });
        }
      } else {
        setState(() {
          rentalList = [];
          groupedList = {};
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget categoryList(String key) {
      return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          height: size.height * 0.3,
          width: size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 216, 238),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      key,
                      overflow: TextOverflow.fade,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RentalSeeMore(
                              company: key, rentalList: groupedList[key])));
                    },
                    child: Text("See More >"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: size * 0.03,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      textStyle: TextStyle(fontSize: 11.0),
                      primary: Theme.of(context).primaryColor,
                    ),
                  )
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
                    return RentalItemList(rental: groupedList[key][index]);
                  },
                  itemCount: groupedList[key].length,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text(UIStrings.sbcbRental),
      ),
      body: groupedList != null
          ? groupedList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupedList.length,
                  itemBuilder: (context, index) {
                    String key = groupedList.keys.elementAt(index);
                    return categoryList(key);
                  })
              : Center(child: Text("No Vehicles to rent!"))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
