import 'package:flutter/material.dart';
import 'package:tsem/models/outlets.dart';

class HeaderSection extends StatelessWidget {
  final Result result;

  HeaderSection(this.result);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: ListTile(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OutletDetail(
          //       outletId: result.outletId,
          //       outletName: result.outletName,
          //     ),
          //   ),
          // );
        },
        leading: Container(
          height: 100,
          width: 50,
          child: ClipOval(child: Image.asset("assets/images/shop.png")),
        ),
        title: Text(
          result.outletName,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
        ),
        subtitle: Text(
          "${result.city} ${result.province}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Container(
          width: 60.0,
          //padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            "${result.outletType}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
