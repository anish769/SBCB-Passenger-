import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/ad.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailPage extends StatelessWidget {
  final Ad ad;

  const AdDetailPage({Key key, @required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ad.title)),
      body: ListView(
        shrinkWrap: true,
        children: [
          Hero(tag: ad.fileUrl, child: Image.network(ad.fileUrl)),
          Divider(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                var latitude = ad.latitude;
                var longitude = ad.longitude;
                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                launch(googleUrl);
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.map,
                    color: Colors.amber,
                  ),
                  Text('Show on map')
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(ad.description),
          ),
          if (ad.contactNum != null)
            GestureDetector(
              onTap: () {
                launch("tel://${ad.contactNum}");
              },
              child: TextField(
                // controller: phone,
                enabled: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.call),
                    labelText: ad.contactNum,
                    enabled: false),
              ),
            ),
          if (ad.webUrl != null)
            GestureDetector(
              onTap: () async {
                var can = await canLaunch(ad.webUrl);
                print(can);
                
                launch(ad.webUrl);
              },
              child: TextField(
                // controller: phone,

                enabled: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.web),
                    labelText: ad.webUrl,
                    enabled: false),
              ),
            )
        ],
      ),
    );
  }
}
