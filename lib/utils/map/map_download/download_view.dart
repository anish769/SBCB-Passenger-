import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/api_urls.dart';
import 'package:pokhara_app/utils/ui_strings.dart';
import 'dart:io';

class MapDownloadView extends StatefulWidget {
  final String path;

  const MapDownloadView({Key key, @required this.path}) : super(key: key);
  @override
  _MapDownloadViewState createState() => _MapDownloadViewState();
}

class _MapDownloadViewState extends State<MapDownloadView> {
  double downloadProgress = 0.0;

  @override
  void initState() {
    downloader();

    super.initState();
  }

  downloader() async {
    Dio dio = new Dio();

    print('save path is : ' + widget.path);
    await dio.download(
      Urls.mapUrl,
      widget.path,
      options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
      onReceiveProgress: (received, total) {
        if (total != -1) {
          // print((received / total * 100).toStringAsFixed(0) + "%");
          if (downloadProgress < (received / total))
            setState(() {
              downloadProgress = (received / total);
            });
        }
        if (received == total) {
          print('downloaded');
          Navigator.pop(context, true);
        }
      },
    ).catchError((error) {
      print(error.toString());
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      insetAnimationCurve: Curves.easeIn,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: height * 0.3,
        width: width * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    UIStrings.downloadingMap,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new Text(
              UIStrings.pleaseWaitMap,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      backgroundColor: Colors.black12,
                      value: downloadProgress,
                    ),
                  ),
                  Text(
                    (downloadProgress * 100).toInt().toString() + "%",
                    textScaleFactor: 1,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
