import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/ad.dart';
import 'package:pokhara_app/view/pages/ad/ad_detail.dart';

class AdViewSlider extends StatefulWidget {
  @override
  _AdViewSliderState createState() => _AdViewSliderState();
}

class _AdViewSliderState extends State<AdViewSlider> {
  List<Ad> ads;

  @override
  void initState() {
    super.initState();
    getAdsAPI().then((value) {
      if (this.mounted)
        setState(() {
          ads = value;
          // ads.forEach((element) => {print(element.fileUrl)});
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    List<Widget> getView() {
      if (ads != null && ads.isNotEmpty) {
        return ads.map((i) {
          return Container(
            padding: EdgeInsets.only(top: 3),
            child: Stack(
              children: <Widget>[
                //image
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdDetailPage(ad: i),
                        ));
                  },
                  child: Container(
                    // width: size.width * 0.25,
                    // height: size.height * 0.24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain, image: NetworkImage(i.fileUrl)),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                        width: media.size.width * 0.76,
                        height: 30,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          gradient: new LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new Text(
                            i.description,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                  bottom: 2,
                )
              ],
            ),
          );
        }).toList();
      } else {
        return [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.grey),
                child: Center(child: CupertinoActivityIndicator()),
              );
            },
          );
        }).toList();
      }
    }

    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.all(1.0),
      child: CarouselSlider(
          options: CarouselOptions(
            // viewportFraction: 0.35,
            height: media.size.height * .29,
            enlargeCenterPage: true,
            reverse: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInOutQuad,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            disableCenter: true,
            autoPlay: true,
          ),
          items: getView()),
    );
  }
}
