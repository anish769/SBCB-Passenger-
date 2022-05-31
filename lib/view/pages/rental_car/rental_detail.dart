import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/rental.dart';
import 'package:pokhara_app/view/widgets/video_items.dart';
import 'package:video_player/video_player.dart';

class RentalDetailPage extends StatefulWidget {
  final Rental rental;

  RentalDetailPage({
    @required this.rental,
  });

  @override
  _RentalDetailPageState createState() => _RentalDetailPageState();
}

class _RentalDetailPageState extends State<RentalDetailPage> {
  String intConvertor(int value) {
    if (value == 0) {
      return "Not Available";
    } else {
      return "Available";
    }
  }

  Widget rowWidget(String title, String description) {
    return Row(
      children: [
        Text(title),
        Spacer(),
        Text(description),
      ],
    );
  }

  Widget contentWidget(Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                  labelText: "Vehicle Info",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              child: Column(
                children: [
                  Hero(
                    tag: widget.rental.vehiclePhoto,
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width,
                      child: Image.network(
                        widget.rental.vehiclePhoto,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  rowWidget("Company Name:", widget.rental.companyName),
                  rowWidget("Vehicle Name:", widget.rental.vehicleName),
                  rowWidget("Daily Rate:",
                      "Rs.  " + widget.rental.dailyRate.toString()),
                  rowWidget("Weekly Rate:",
                      "Rs. " + widget.rental.weeklyRate.toString()),
                  rowWidget("Monthly Rate:",
                      "Rs. " + widget.rental.monthlyRate.toString()),
                  rowWidget(
                      "Seat Capacity:", widget.rental.seatCapacity.toString()),
                  rowWidget("Carrier Availability:",
                      intConvertor(widget.rental.careerAvailablity)),
                  rowWidget("Fuel Type:", widget.rental.fuelType),
                  rowWidget("Ground Clearance:", widget.rental.groundClearance),
                  rowWidget("Boot Space:", widget.rental.bootSpace),
                  rowWidget("Mileage:", widget.rental.mileage),
                  rowWidget("Wheeler Type:", widget.rental.wheelerType),
                  rowWidget("Driver Airbag:",
                      intConvertor(widget.rental.driverAirbag)),
                  rowWidget("Passenger Airbag:",
                      intConvertor(widget.rental.passengerAirbag)),
                  rowWidget("AC Front:",
                      intConvertor(widget.rental.acFront).toString()),
                  rowWidget("AC Rear:",
                      intConvertor(widget.rental.acRear).toString()),
                  rowWidget("Heater Front:",
                      intConvertor(widget.rental.heaterFront).toString()),
                  rowWidget("Heater Rear:",
                      intConvertor(widget.rental.heaterRare).toString()),
                  rowWidget(
                      "Fuel Provider:", widget.rental.fuelProvider.toString()),
                  rowWidget("Driver Expense:",
                      widget.rental.driverExpenses.toString()),
                  rowWidget("Remarks:", widget.rental.remarks.toString()),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            InputDecorator(
              decoration: InputDecoration(
                  labelText: "Driver Info",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    child: Image.network(
                      widget.rental.driverPhoto,
                      fit: BoxFit.contain,
                    ),
                  ),
                  rowWidget("Driver Name:", widget.rental.driverName),
                  rowWidget("Driver Address:", widget.rental.driverAddress),
                  rowWidget("Driver Phone:", widget.rental.driverPhone),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              height: size.height * 0.3,
              width: size.width * 0.8,
              child: VideoItems(
                videoPlayerController: VideoPlayerController.network(
                    widget.rental.vehicleVideoClip),
                looping: false,
                autoplay: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.rental.vehicleName)),
        body: contentWidget(size),
      ),
    );
  }
}
