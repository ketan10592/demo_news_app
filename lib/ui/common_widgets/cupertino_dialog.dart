import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCupertinoAlertDialogWithTwoButtonsMethod(
    BuildContext context, {
      String? title,
      String? body,
      String? firstButtonText = '',
      String? secondButtonText = '',
      VoidCallback? callbackForFirstButton,
      VoidCallback? callbackForScondButton,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: <Widget>[
          if (firstButtonText!.isNotEmpty)
            CupertinoDialogAction(
              child: Text(firstButtonText),
              onPressed: callbackForFirstButton,
            ),
          if (secondButtonText!.isNotEmpty)
            CupertinoDialogAction(
              child: Text(secondButtonText),
              onPressed: callbackForScondButton,
            ),
        ],
      );
    },
  );
}