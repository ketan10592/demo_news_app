import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoLoading{
  static progressDialog(bool isLoading, BuildContext context) {

    if (!isLoading) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return CupertinoLoadingLayout();
        },
        useRootNavigator: true,
      );
    }
  }
}

class CupertinoLoadingLayout extends StatefulWidget {
  @override
  _CupertinoLoadingLayoutState createState() => _CupertinoLoadingLayoutState();
}

class _CupertinoLoadingLayoutState extends State<CupertinoLoadingLayout>{

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(radius: 15,);
  }
}