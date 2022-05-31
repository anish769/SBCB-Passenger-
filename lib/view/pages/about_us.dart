import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget tappableText(String url) {
      return GestureDetector(
          child: Text(
            !url.contains("//") ? url.split(':')[1] : url.split("//")[1],
            style: TextStyle(
                fontSize: 15.0,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.double),
          ),
          onTap: () => launch(url));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "About Us",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Center(
            child: Column(
              children: <Widget>[
                Hero(
                  tag: 'info',
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Image.asset(Assets.technosales),
                  ),
                ),
                Text(
                  "Technology Sales Pvt. Ltd",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "ISO 9001:2015 Certified Company",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Address ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.location_on)
                  ],
                ),
                Text(
                  "Neel Saraswati marg: 669\nLazimpat, Kathmandu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Phone  ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.phone)
                  ],
                ),
                tappableText("tel:01-4416900"),
                tappableText("tel:01-4444576"),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Email   ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.email)
                  ],
                ),
                tappableText("mailto:info@technosales.com.np"),
                tappableText("mailto:rlmachine@yahoo.com"),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Website   ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.web)
                  ],
                ),
                tappableText(
                  "http://www.technosales.com.np",
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Developers  ",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.developer_mode)
                  ],
                ),
                Text("Aayush Subedi | Siddhartha Sapkota")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
