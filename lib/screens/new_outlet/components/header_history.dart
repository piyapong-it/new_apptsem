import 'package:flutter/material.dart';
import 'package:tsem/models/outletrequest.dart';

class HeaderHistory extends StatelessWidget {
  final NewOutletRequest result;
  HeaderHistory(this.result);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: result.requestStatus == 'APPROVED' ? Colors.green.shade200: Colors.orange.shade200,
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
          result.cmOutlName,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
        ),
        
        subtitle: Text(
          "${result.cmOutlAddr6} , ${result.cmProvinceEn}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Container(
          alignment: Alignment.center,
          width: 80.0,
          child: Text(
            result.requestStatus,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
