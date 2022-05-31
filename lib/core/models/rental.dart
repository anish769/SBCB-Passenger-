import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:pokhara_app/utils/utilities.dart';

class Rental {
  int id;
  String companyName;
  String vehicleName;
  int seatCapacity;
  int careerAvailablity;
  String fuelType;
  String groundClearance;
  String bootSpace;
  String mileage;
  String wheelerType;
  int driverAirbag;
  int passengerAirbag;
  int acFront;
  int acRear;
  int heaterFront;
  int heaterRare;
  int dailyRate;
  int weeklyRate;
  int monthlyRate;
  String fuelProvider;
  String driverExpenses;
  String vehiclePhoto;
  String vehicleVideoClip;
  String remarks;
  String driverName;
  String driverAddress;
  String driverPhone;
  String driverPhoto;
  String createdAt;
  String updatedAt;

  Rental(
      {this.id,
      this.companyName,
      this.vehicleName,
      this.seatCapacity,
      this.careerAvailablity,
      this.fuelType,
      this.groundClearance,
      this.bootSpace,
      this.mileage,
      this.wheelerType,
      this.driverAirbag,
      this.passengerAirbag,
      this.acFront,
      this.acRear,
      this.heaterFront,
      this.heaterRare,
      this.dailyRate,
      this.weeklyRate,
      this.monthlyRate,
      this.fuelProvider,
      this.driverExpenses,
      this.vehiclePhoto,
      this.vehicleVideoClip,
      this.remarks,
      this.driverName,
      this.driverAddress,
      this.driverPhone,
      this.driverPhoto,
      this.createdAt,
      this.updatedAt});

  Rental.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    vehicleName = json['vehicle_name'];
    seatCapacity = json['seat_capacity'];
    careerAvailablity = json['career_availablity'];
    fuelType = json['fuel_type'];
    groundClearance = json['ground_clearance'];
    bootSpace = json['boot_space'];
    mileage = json['mileage'];
    wheelerType = json['wheeler_type'];
    driverAirbag = json['driver_airbag'];
    passengerAirbag = json['passenger_airbag'];
    acFront = json['ac_front'];
    acRear = json['ac_rear'];
    heaterFront = json['heater_front'];
    heaterRare = json['heater_rare'];
    dailyRate = json['daily_rate'];
    weeklyRate = json['weekly_rate'];
    monthlyRate = json['monthly_rate'];
    fuelProvider = json['fuel_provider'];
    driverExpenses = json['driver_expenses'];
    vehiclePhoto = Urls.imgDwnPrefix + json['vehicle_photo'];
    vehicleVideoClip = Urls.imgDwnPrefix + json['vehicle_video_clip'];
    remarks = json['remarks'];
    driverName = json['driver_name'];
    driverAddress = json['driver_address'];
    driverPhone = json['driver_phone'];
    driverPhoto = Urls.imgDwnPrefix + json['driver_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['vehicle_name'] = this.vehicleName;
    data['seat_capacity'] = this.seatCapacity;
    data['career_availablity'] = this.careerAvailablity;
    data['fuel_type'] = this.fuelType;
    data['ground_clearance'] = this.groundClearance;
    data['boot_space'] = this.bootSpace;
    data['mileage'] = this.mileage;
    data['wheeler_type'] = this.wheelerType;
    data['driver_airbag'] = this.driverAirbag;
    data['passenger_airbag'] = this.passengerAirbag;
    data['ac_front'] = this.acFront;
    data['ac_rear'] = this.acRear;
    data['heater_front'] = this.heaterFront;
    data['heater_rare'] = this.heaterRare;
    data['daily_rate'] = this.dailyRate;
    data['weekly_rate'] = this.weeklyRate;
    data['monthly_rate'] = this.monthlyRate;
    data['fuel_provider'] = this.fuelProvider;
    data['driver_expenses'] = this.driverExpenses;
    data['vehicle_photo'] = this.vehiclePhoto;
    data['vehicle_video_clip'] = this.vehicleVideoClip;
    data['remarks'] = this.remarks;
    data['driver_name'] = this.driverName;
    data['driver_address'] = this.driverAddress;
    data['driver_phone'] = this.driverPhone;
    data['driver_photo'] = this.driverPhoto;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

Future<List<Rental>> getRental() async {
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final response = await http.get(
      Uri.parse(Urls.rental),
      headers: header,
    );
    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (!mapResponse["error"]) {
        final data = mapResponse["data"].cast<Map<String, dynamic>>();
        final List<Rental> rentals = await data.map<Rental>((json) {
          return Rental.fromJson(json);
        }).toList();
        return rentals;
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
