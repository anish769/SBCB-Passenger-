import 'package:flutter/material.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi.dart';
import 'package:pokhara_app/core/models/vehicles/taxi/taxi_response.dart';
import 'package:pokhara_app/core/notifiers/providers/taxi_state.dart';
import 'package:pokhara_app/utils/utilities.dart';
import 'package:provider/provider.dart';

class TaxiRatingView extends StatefulWidget {
  final Taxi taxi;

  TaxiRatingView({@required this.taxi});

  @override
  _TaxiRatingViewState createState() => _TaxiRatingViewState();
}

class _TaxiRatingViewState extends State<TaxiRatingView> {
  int ratingVal = 0;
  final TextEditingController _comment = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    ' Requesting Vehicle',
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
                'Rate Taxi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Hope your trip was a joy. Please rate the taxi service!',
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ),
      );
    }

    Widget rateButton() {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: FlatButton(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () async {
              if (ratingVal == 0) {
                Utilities.showInToast('Please input rating',
                    toastType: ToastType.INFO);
                return;
              }
              TaxiResponse resp =
                  Provider.of<TaxiState>(context, listen: false).taxiResponse;
              var dist = resp.message.split(',').first;
              var amt = resp.message.split(',').last;

              var res = await endTripAPI(resp.requestId, ratingVal, dist, amt,
                  comment: _comment.text);
              if (res)
                Utilities.showInToast('Thank you!',
                    toastType: ToastType.SUCCESS);
              Navigator.pop(context, res);
            },
            color: Theme.of(context).primaryColor,
            child: Text(
              'Rate',
            ),
          ),
        ),
      );
    }

    Widget rateGesture(int value) {
      return GestureDetector(
        onTap: () {
          setState(() {
            ratingVal = value;
          });
        },
        child: Icon(
          Icons.star,
          size: 35,
          color: ratingVal >= value
              ? Theme.of(context).primaryColor
              : Colors.black26,
        ),
      );
    }

    Widget rateBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            rateGesture(1),
            rateGesture(2),
            rateGesture(3),
            rateGesture(4),
            rateGesture(5),
          ],
        ),
      );
    }

    Widget cancelButton() {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: FlatButton(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            child: Text(
              'Cancel',
            ),
          ),
        ),
      );
    }

    return Dialog(
        insetAnimationCurve: Curves.easeIn,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Container(
            // height: height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header(),
                descriptionWidget(),
                rateBar(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _comment,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.comment), hintText: 'Comment'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    rateButton(),
                    cancelButton(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
