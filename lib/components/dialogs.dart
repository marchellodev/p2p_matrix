import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(key: key, children: [
                Center(
                  child: Column(children: const [
                    CircularProgressIndicator(),
                  ]),
                )
              ]));
        });
  }
}
