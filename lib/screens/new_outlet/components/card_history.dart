import 'package:flutter/material.dart';
import 'package:tsem/models/outletrequest.dart';

import 'header_history.dart';

class CardHistory extends StatelessWidget {
  final NewOutletRequest result;

  CardHistory(this.result);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      child: Column(
        children: [
          HeaderHistory(result),
        ],
      ),
    );
  }
}
