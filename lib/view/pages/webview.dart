import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewss();
  }
}

class WebViewss extends State<WebViews> {
  bool isloading = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 97, 12, 90),
          title: Text("Sambridhhi Mart"),
        ),
        body: Stack(
          children: [
            WebView(
              onPageFinished: (finish) {
                setState(() {
                  isloading = false;
                });
              },
              initialUrl: Assets.webview,
              javascriptMode: JavascriptMode.unrestricted,
            ),
            isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ));
  }
}
