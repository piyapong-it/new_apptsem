import 'package:flutter/material.dart';
import 'package:tsem/models/outletnearby.dart';

import 'body_section.dart';
import 'header_section.dart';

class CardSection extends StatelessWidget {
  final Result result;

  CardSection(this.result);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      child: Column(
        children: [
          HeaderSection(result),
          BodySection(result),
        ],
      ),
    );
  }
}
