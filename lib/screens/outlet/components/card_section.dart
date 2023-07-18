import 'package:flutter/material.dart';
import 'package:tsem/models/outlets.dart';

import 'body_section.dart';
import 'header_section.dart';
import 'footer_section.dart';

class CardSection extends StatelessWidget {
  final Result result;
  final String department; 

  CardSection(this.result, this.department);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      child: Column(
        children: [
          HeaderSection(result),
          BodySection(result),
         department == 'TSM' ? SizedBox() :FooterSection(result),
        ],
      ),
    );
  }
}
