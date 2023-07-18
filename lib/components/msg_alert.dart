import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class MessageAlert {

  void okAlert({BuildContext context,String message, String title}) {
    //Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void functAlert({BuildContext context,String message, Function function}) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(message,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.black,
              )),
          actions: [
            CupertinoDialogAction(
              onPressed: function,
              child: Text("Ok"),
            )
          ],
        );
      },
    );
  }
}
