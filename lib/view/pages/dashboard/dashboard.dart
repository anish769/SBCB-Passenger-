import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:pokhara_app/view/pages/dashboard/ad_view_slider.dart';
import 'package:pokhara_app/view/pages/dashboard/menu_grid.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatelessWidget { 
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget topBar() {
      return AdViewSlider();
    }

    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.grey[300],
        drawer: Drawer(),
        drawerEnableOpenDragGesture: true,
        endDrawerEnableOpenDragGesture: true,
        body: Column(
          children: [
            topBar(),
            marqueeWIdget(size, context),
            MenuGrid(),
          ],
        ),
      ),
    );
  }

  Container marqueeWIdget(Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      height: size.height * 0.050,
      color: Color.fromARGB(255, 2, 62, 58),
      child: GestureDetector(
        onTap: () {
          launch('https://mlaundry.com.np/');
        },
        child: Marquee(
          text:
              'Myagdi Laundry & pest Control services || म्याग्दी लाउन्ड्री एन्ड पेष्ट कन्ट्रोल सर्भिस || Click Here ||',

          style: TextStyle(color: Colors.white, fontSize: 18),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 5.0,
          velocity: 50.0,
          pauseAfterRound: Duration(seconds: 1),
          // startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}
