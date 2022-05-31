class Constants {
  //constants that will be used throught the app
  static bool isProduction = true;
  // static const appServerType = "PRODUCTION";
  static const timeOutSec = 120;
  static const taxiReqTimeoutSec = 120;
  static const localDB = 'sqlite_local.db';
  static const securityKey = 'U0VXQWZvckV2ZXJ5TmVwYWxWZWhpY2xl';
  static var token = '';
  static var currentLang = Lang.ENG; //default ENG
  static var callServerNum1 = '9801980384';
  static var callServerNum = '9808075700';
  static const accessEmail = 'sbcbadmin';
  // static var appUser = '2220';

  static const sbcbLogo = 'assets/img/sbcb.png';
  static String referalNumber;

  static const googleAPIKey = "AIzaSyC_siAOGtkjHJ4i_1SzyjaSV8VC83vfYAw";

  static int initialRateTaxi = 150;
  static int abc = 150;
  static int taxiPerKm = 39;
  static int bikePerKm = 20;
  static int initialRateBike = 100;

  static const playstoreShareLink =
      "https://play.google.com/store/apps/details?id=com.techsales.sbcb";
  static const appstoreShareLink =
      "https://apps.apple.com/us/app/sambriddha-group/id1589649235";
}

class Assets {
  static const appLogo = 'assets/img/applogo.gif';
  static const technosales = 'assets/img/technosales.png';
  static const defaultUserIcon = 'assets/img/default_user.png';
  static const sbcbLogo = 'assets/img/sbcb.png';

  //taxi
  static const taxi1 = 'assets/img/vehicles/taxi1.png';
  static const taxi = 'assets/img/vehicles/taxi.png';
  static const bike1 = 'assets/img/vehicles/bike1.png';
  static const bike = 'assets/img/vehicles/bike.png';

  //private vehicles
  static const onlinePrivateVehicle =
      'assets/img/vehicles/moving_private_vehicle.png';
  static const offlinePrivateVehicle =
      'assets/img/vehicles/moving_private_vehicle_offline.png';

  //webview
  static const webview = "https://sbcb.com.np/";

  //map
  static const KTMmapFile = 'assets/map/ktm.mbtiles';
  static const PKRmapFile = 'assets/map/pkr.mbtiles';
}

enum Lang { NP, ENG }

class VehicleType {
  static String both = "both";
  static String taxi = "taxi";
  static String bike = "bike";
}
