import 'package:flutter/material.dart';
import 'package:pokhara_app/utils/ui_strings.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 97, 12, 90),
        title: Text(UIStrings.transport),
      ),
      body: Center(
        child: Text(
          "Under Construction..",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
