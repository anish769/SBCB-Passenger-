import 'package:flutter/foundation.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi_response.dart';

class TaxiState extends ChangeNotifier {
  Taxi _active;

  TaxiResponse _tResponse;

  get activeTaxi => _active;

  get taxiResponse => _tResponse;

  setActiveTaxi(Taxi taxi) {
    _active = taxi;
    notifyListeners();
  }

  setActiveTaxiResponse(TaxiResponse resp) {
    _tResponse = resp;
    notifyListeners();
  }
}
