import 'package:pokhara_app/utils/constants.dart';

class UIStrings {
  static final appName = 'SBCB';

  static var mapSavePath = '';

  static get register =>
      Constants.currentLang == Lang.ENG ? "Register" : "दर्ता गर्नुहोस्";
  static get login => Constants.currentLang == Lang.ENG ? "Login" : "लग - इन";
  static get username =>
      Constants.currentLang == Lang.ENG ? "User Name" : "प्रयोगकर्ता नाम";
  static get localBus =>
      Constants.currentLang == Lang.ENG ? "Local Bus" : "स्थानीय बस";
  static get taxiBooking =>
      Constants.currentLang == Lang.ENG ? "Taxi Service" : "ट्याक्सी सेवा";
  static get catchBus => Constants.currentLang == Lang.ENG
      ? "Catch a bus from here"
      : "यहाँबाट एउटा बस खोज्नुहोस";
  static get bookTaxi => Constants.currentLang == Lang.ENG
      ? "Book a taxi from here"
      : "यहाँबाट ट्याक्सी बुक गर्नुहोस";
  static get vehicleTrack => Constants.currentLang == Lang.ENG
      ? "Track your vehicles"
      : "तपाईंको सवारी साधन ट्र्याक गर्नुहोस्";
  static get privateVehicle =>
      Constants.currentLang == Lang.ENG ? "Private Vehicle" : "निजी साधन";
  static get share =>
      Constants.currentLang == Lang.ENG ? "Share" : "सेयर गर्नुहोस्";
  static get shareLocation => Constants.currentLang == Lang.ENG
      ? "Share your realtime location"
      : "तपाईंको रियलटाइम स्थान साझा गर्नुहोस्";
  static get locationSharing => Constants.currentLang == Lang.ENG
      ? "Location Sharing"
      : "स्थान साझा गर्नुहोस्";
  static get subscrired =>
      Constants.currentLang == Lang.ENG ? "Subscribed" : "सदस्यता लिइयो";
  static get daysLeft =>
      Constants.currentLang == Lang.ENG ? "Days left" : "बाकी दिन";
  static get privacyPolicy =>
      Constants.currentLang == Lang.ENG ? "Privacy Policy" : "गोपनीयता नीति";
  static get aboutUs =>
      Constants.currentLang == Lang.ENG ? "About Us" : "हाम्रोबारे";
  static get settings =>
      Constants.currentLang == Lang.ENG ? "Settings" : "सेटिंग्स";
  static get webview =>
      Constants.currentLang == Lang.ENG ? "Website" : "वेब दृश्य";
  static get transport =>
      Constants.currentLang == Lang.ENG ? "Transport Service" : "ढुवानी सेवा";
  static get logout => Constants.currentLang == Lang.ENG ? "Logout" : "लगआउट";
  static get profile =>
      Constants.currentLang == Lang.ENG ? "Profile" : "प्रोफाइल";
  static get email => Constants.currentLang == Lang.ENG ? "Email" : "ईमेल";
  static get noName =>
      Constants.currentLang == Lang.ENG ? "No Name" : "नाम छैन";
  static get noEmail =>
      Constants.currentLang == Lang.ENG ? "No Email" : "ईमेल छैन";
  static get phone => Constants.currentLang == Lang.ENG ? "Phone" : "फोन";
  static get mobNum =>
      Constants.currentLang == Lang.ENG ? "Mobile Number" : "मोबाइल नम्बर";
  static get address =>
      Constants.currentLang == Lang.ENG ? "address" : "ठेगाना";
  static get joined =>
      Constants.currentLang == Lang.ENG ? "Joined On" : "सदस्यता";
  static get save => Constants.currentLang == Lang.ENG ? "Save" : "बचत";
  static get routes =>
      Constants.currentLang == Lang.ENG ? "Routes" : "मार्गहरू";
  static get stations =>
      Constants.currentLang == Lang.ENG ? "Stations" : "स्टेशनहरु";
  static get myLocation =>
      Constants.currentLang == Lang.ENG ? "My Location" : "मेरो स्थान";
  static get searchRouteOrBus => Constants.currentLang == Lang.ENG
      ? "Search Route or Bus"
      : "मार्ग वा बस खोजी गर्नुहोस्";
  static get noResult =>
      Constants.currentLang == Lang.ENG ? "No Result" : "परिणाम छैन";
  static get tenDigit => Constants.currentLang == Lang.ENG
      ? "Please input 10 digit number"
      : "कृपया १० नम्बर इनपुट गर्नुहोस्";
  static get agreeTerms => Constants.currentLang == Lang.ENG
      ? "Please agree to the terms!"
      : "सर्तहरू मा सहमत गर्नुहोस्!";
  static get noNetwork => Constants.currentLang == Lang.ENG
      ? "No network connection!"
      : "इन्टरनेट छैन";
  static get iAgree => Constants.currentLang == Lang.ENG
      ? "I agree to the Terms and Conditions"
      : "म नियम र सर्तहरूमा सहमत छु";
  static get confirmLogout => Constants.currentLang == Lang.ENG
      ? "Confirm Logout?"
      : "लगआउट गर्न चाहानुहुन्छ?";
  static get close => Constants.currentLang == Lang.ENG ? "Close" : "बन्द";

  static get loginMessage => Constants.currentLang == Lang.ENG
      ? "Enter your phone number to login and call from the same number as seen"
      : "लगईन को लागी तपाईको फोन नम्बर हाल्नुहोस् र देखिएको नम्बर मा सोही नम्बर बाट कल गर्नुहोस ";
  static get registerMessage => Constants.currentLang == Lang.ENG
      ? "Please call the registered number to login"
      : "लगइन गर्न दर्ता गरिएको नम्बरमा कल गर्नुहोस्";
  static get language =>
      Constants.currentLang == Lang.ENG ? "Language" : "भाषा";
  static get pleaseWaitMap => Constants.currentLang == Lang.ENG
      ? "Please wait while the map is downloading"
      : "कृपया नक्सा डाउनलोड हुने बखत प्रतीक्षा गर्नुहोस्";
  static get downloadingMap => Constants.currentLang == Lang.ENG
      ? "Downloading Map"
      : "नक्शा डाउनलोड गर्दै";
  static get errorBus => Constants.currentLang == Lang.ENG
      ? "Error fetching buses"
      : "बसहरू प्राप्त गर्दा त्रुटि";
  static get errorStation => Constants.currentLang == Lang.ENG
      ? "Error fetching stations"
      : "स्टेशनहरू प्राप्त गर्दा त्रुटि";
  static get errorTaxi => Constants.currentLang == Lang.ENG
      ? "Error fetching taxi"
      : "ट्याक्सीहरू प्राप्त गर्दा त्रुटि";
  static get errorAds => Constants.currentLang == Lang.ENG
      ? "Failed to get ads."
      : "विज्ञापन प्राप्त गर्न असफल भयो।";
  static get errorRoute => Constants.currentLang == Lang.ENG
      ? "Error fetching routes"
      : "मार्गहरू प्राप्त गर्दा त्रुटि";
  static get fillAllField => Constants.currentLang == Lang.ENG
      ? "please fill all required field"
      : "कृपया सबै आवश्यक फिल्ड भर्नुहोस्";
  static get search => Constants.currentLang == Lang.ENG ? "Search" : "खोजी";
  static get exploreAds =>
      Constants.currentLang == Lang.ENG ? "Explore " : "विज्ञापन अन्वेषण ";
  static get sbcbKrishi =>
      Constants.currentLang == Lang.ENG ? "SBCB Market " : "SBCB बजार";
  static get hamroKrishiSub => Constants.currentLang == Lang.ENG
      ? "Buy Indigenous product "
      : "स्वदेशी उत्पादन पाउने ठाउँ";
  static get sbcbRental =>
      Constants.currentLang == Lang.ENG ? "SBCB Rental " : "रेन्टअल";
  static get sbcbRentalSub => Constants.currentLang == Lang.ENG
      ? "Rent car here "
      : "यहाँ कार भाँडामा लिनुहोस्";

  // krishi category
  static get gedagudi =>
      Constants.currentLang == Lang.ENG ? "Gedagudi" : "गेडागुडी";
  static get fruits => Constants.currentLang == Lang.ENG ? "Fruits" : "फलफुल";
  static get vegetables =>
      Constants.currentLang == Lang.ENG ? "Vegetables" : "तरकारी";
  static get spices => Constants.currentLang == Lang.ENG ? "Spices" : "मसला";
  static get homemadeClothes => Constants.currentLang == Lang.ENG
      ? "Indigenous textiles and others"
      : "स्वदेशी उत्पदित कपडा तथा अन्य";
  static get birdMeat => Constants.currentLang == Lang.ENG
      ? "Bird Category meat"
      : "पक्षि जन्य मासु";
  static get animalMeat => Constants.currentLang == Lang.ENG
      ? "Animal Category meat"
      : "पशु जन्य मासु";
  static get fish => Constants.currentLang == Lang.ENG ? "Fish" : "माछा";
  static get others => Constants.currentLang == Lang.ENG ? "Others" : "अन्य";

  // rental category
  static get honda => Constants.currentLang == Lang.ENG ? "Honda" : "होन्डा";
  static get mahindra =>
      Constants.currentLang == Lang.ENG ? "Mahindra" : "महिन्द्र";
  static get hyundai =>
      Constants.currentLang == Lang.ENG ? "Hyundai" : "ह्युन्दै";
  static get marutiSuzuki =>
      Constants.currentLang == Lang.ENG ? "Maruti Suzuki" : "मरुती सुजुकी";
  static get renault =>
      Constants.currentLang == Lang.ENG ? "Renault" : "रेनौल्त";
  static get volkswagen =>
      Constants.currentLang == Lang.ENG ? "Volkswagen" : "वोल्क्स्वगेन";
  static get tata => Constants.currentLang == Lang.ENG ? "TATA" : "टाटा";
  static get kia => Constants.currentLang == Lang.ENG ? "KIA" : "किआ";
  static get jeep => Constants.currentLang == Lang.ENG ? "Jeep" : "जीप";
  static get mitsubishi =>
      Constants.currentLang == Lang.ENG ? "Mitsubishi" : "मिट्सुबिशी";
  static get nissan => Constants.currentLang == Lang.ENG ? "Nissan" : "निस्सन";
  static get toyota => Constants.currentLang == Lang.ENG ? "Toyota" : "टोयोटा";
  static get ford => Constants.currentLang == Lang.ENG ? "Ford" : "फोर्ड";
  static get peugeot =>
      Constants.currentLang == Lang.ENG ? "Peugeot" : "पेउगेओत";
  static get skoda => Constants.currentLang == Lang.ENG ? "Skoda" : "स्कोडा";
}
