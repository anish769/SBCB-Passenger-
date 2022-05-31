import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:pokhara_app/core/notifiers/app_providers.dart';
// import 'package:pokhara_app/utils/map_download/map_downloader.dart';
import 'package:pokhara_app/view/pages/splash.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'utils/ui_strings.dart';

void main() async {
  developer.log("This is developer log func message", name: 'MyLog');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getproviders(),
      child: MaterialApp(
        title: UIStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 97, 12, 90),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
