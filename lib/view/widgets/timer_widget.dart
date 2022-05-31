import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/constants.dart';

Timer _timer;

Widget timerWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      child: Center(
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
    ),
  );
}
