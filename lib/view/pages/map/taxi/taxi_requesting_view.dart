import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/constants.dart';

class TaxiRequestingView extends StatefulWidget {
  Function cancelRequest;
  Function requestAPI;
  String name;
  Function cancelAllRequest;

  TaxiRequestingView(
      {@required this.cancelRequest,
      @required this.requestAPI,
      @required this.name,
      @required this.cancelAllRequest});

  @override
  _TaxiRequestingViewState createState() => _TaxiRequestingViewState();
}

class _TaxiRequestingViewState extends State<TaxiRequestingView> {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (t.tick <= Constants.taxiReqTimeoutSec) {
        setState(() {});
      } else {
        print('Timeout!');
        t.cancel();
        widget.cancelAllRequest();

        // cancelRequest();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget timerWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: (Constants.taxiReqTimeoutSec - _timer.tick) /
                    Constants.taxiReqTimeoutSec,
                strokeWidth: 2,
                backgroundColor: Colors.black12,
              ),
              Center(
                  child: Text(
                      (Constants.taxiReqTimeoutSec - _timer.tick).toString())),
            ],
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        height: 40,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_taxi,
                    color: Colors.white,
                  ),
                  Text(
                    ' ' + widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget descriptionWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'REQUESTING TAXI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
                'Please wait while the request is being carried on. The request is automatically canceled after 120 seconds.',
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      );
    }

    Widget cancelButton() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: FlatButton(
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            widget.cancelRequest();
          },
          color: Colors.red,
          child: Text(
            'Cancel Request',
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Color.fromARGB(255, 164, 103, 103),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(),
              descriptionWidget(),
              timerWidget(),
              cancelButton(),
            ],
          ),
        ),
      ),
    );
  }
}
