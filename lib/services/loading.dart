import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SpinKitFadingCircle(
          color: Theme.of(context).primaryColor,
          size: 50,
        ),
      ),
    );
  }
}
