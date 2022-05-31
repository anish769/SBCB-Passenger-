import 'package:pokhara_app/utils/constants.dart';

class Urls {
  /// production start

  static String get _mainUrl => Constants.isProduction
      ? "http://117.121.237.226:86/sbcb/" //Production
      : "http://202.52.240.148:8092/sbcb/"; //test

  static String get endPoint => _mainUrl + "api/";

  static final String photoUrl = _mainUrl;

  static final String adsPrefixUrl = _mainUrl;

  // static final String adsPrefixUrl = Constants.isProduction
  //     ? 'http://117.121.237.226:86/sbcb/' //Production
  //     : 'http://202.52.240.148:8092/sbcb/'; //test

  /// production end

  ///Resister URL can be used for update also
  static final String registerUrl = endPoint + "taxi/app_user";

  static final String loginUrl = endPoint + "taxi/postLogin";

  static final String mapUrl = "http://202.52.240.149/map/nepal-latest-gh";

  /*Taxi Urls*/
  static final String taxiList = endPoint + "taxi/list";

  static final String taxiView = endPoint + "taxi/view";

  static final String endTrip = endPoint + "taxi/end_trip";

  static final String taxiRatingDisplay = endPoint + "taxi/rating_display";

  static final String taxiRequest = endPoint + "taxi/request";

  static final String taxiPathaoRequest = _mainUrl + "taxi/near-taxi-request";

  static final String taxiCancelRequest = endPoint + "taxi/cancelRequest";
  static final String taxiAllCancelRequest = endPoint + "taxi/cancelTimeout";

  static final String updateUserLocation =
      endPoint + "taxi/update_user_location";

  /*profile Urls*/
  static String profileUpdate = endPoint + 'taxi/updateProfile';

  /*share via sms*/
  static String shareViaSMS = endPoint + "refer";
  static String notificationUrl = "http://117.121.237.226:86/sbcb/topic";

  /*Location Share Urls*/
  static String shareLocation = endPoint + "shareLocation";

  static String locationUpdate = endPoint + "updateLocation";

  static String shareBack = endPoint + "shareChild";

  static String stopSharing = endPoint + "reviewShare";

  // for private vehicles (gps nepal)
  static final String privateMainUrl =
      "http://202.52.240.149:82/route_api_v3/public/api/private/";

  // for ads

  static final String adsList = endPoint + 'get_ads';
  static final String searchAd =
      endPoint + 'ads/search?keyword='; //param keyword
  static final String imgDwnPrefix = adsPrefixUrl + 'public/storage/';

  static final String driverPicUrl = _mainUrl + 'public/uploads/taxi_profile/';

  static final String marketCategoriesUrl = endPoint + 'categories';
  static final String marketItems = endPoint + 'items';

  static final String rental = endPoint + 'get_rentals';

  // call server
  static final String _callServerUrl =
      'http://202.52.240.148:8092/callserver/api/';
  static final String getServerNum =
      _callServerUrl + 'get_server_number?client_id=1';

  ///call_record_verification?mobile_number=9841372105&server_number=9841345921
  static final String verifyCall = _callServerUrl + 'call_record_verification?';

  // static final String callServerUrl =
  //     _callServerUrl + 'call_record_verification/';
  static final String callServerUrl =
      'http://202.52.240.149:82/callserver/public/api/phone_verification/';
}
