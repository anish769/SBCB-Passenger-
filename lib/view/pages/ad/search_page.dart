import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/ad.dart';
import 'package:pokhara_app/view/pages/ad/ad_detail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isSearching = false;
  List<Ad> ads;
  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return TextField(
        onChanged: (s) {
          //searching only if 3 chars are entered
          if (s.length < 3) {
            setState(() {
              ads = null;
              _isSearching = false;
            });
            return;
          }
          setState(() {
            _isSearching = true;
          });
          searchAdsAPI(s).then((value) {
            setState(() {
              ads = value;

              setState(() {
                _isSearching = false;
              });
            });
          });
        },
        decoration: InputDecoration(
            prefixIcon: Hero(tag: 'Search', child: Icon(Icons.search))),
      );
    }

    Widget adsListView() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ads.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdDetailPage(ad: ads[index]),
                    ));
                // var latitude = ads[index].latitude;
                // var longitude = ads[index].longitude;
                // String googleUrl =
                //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                // launch(googleUrl);
              },
              leading: Hero(
                  tag: ads[index].fileUrl,
                  child: Image.network(ads[index].fileUrl)),
              title: Text(ads[index].title),
              subtitle: Text(ads[index].description),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text('Search'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          searchBar(),
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            )
          else if (ads == null)
            Padding(
              padding: const EdgeInsets.all(68.0),
              child: Center(
                child: Text(
                  'Search Ads',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              ),
            )
          else if (ads.isEmpty)
            Padding(
              padding: const EdgeInsets.all(68.0),
              child: Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 30, color: Colors.black38),
                ),
              ),
            )
          else
            adsListView()
        ],
      ),
    );
  }
}
