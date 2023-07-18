import 'package:flutter/material.dart';
import 'package:tsem/models/outlets.dart';

class BodySection extends StatelessWidget {
  final Result result;

  BodySection(this.result);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //_launchDetail(outletId: result.outletId);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(result.outletId),
              subtitle: Text(
                "${result.address}"
                "\n${result.salesName}",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ));
  }
}
