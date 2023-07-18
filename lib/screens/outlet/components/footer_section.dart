import 'package:flutter/material.dart';
import 'package:tsem/models/outlets.dart';
import 'package:tsem/screens/asset/asset_master.dart';
import 'package:tsem/screens/complaint/complaint.dart';
import 'package:tsem/screens/outlet_detail/outlet_detail.dart';
import 'package:tsem/screens/outlet_map/outlet_map_screen.dart';
import 'package:tsem/screens/task/task.dart';
import 'package:tsem/screens/visit_start/visit_start.dart';
import 'package:tsem/screens/visit_history/visit_history.dart';

class FooterSection extends StatelessWidget {
  final Result result;

  FooterSection(this.result);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(2.0),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        
        children: [
          
          ButtomflatButton(
              icon: Icons.history,
              text: "History",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitHistory(
                      outletId: result.outletId,
                      outletName: result.outletName,
                    ),
                  ),
                );
              }
              ),
          ButtomflatButton(
              icon: Icons.sports_bar_rounded,
              text: "Asset",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetMaster(
                      outletId: result.outletId,
                      outletName: result.outletName,
                    ),
                  ),
                );
              }),
          ButtomflatButton(
              icon: Icons.assignment_late_outlined,
              text: "Task",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(
                      outletId: result.outletId,
                      outletName: result.outletName,
                    ),
                  ),
                );
              }),
          ButtomflatButton(
              icon: Icons.add_call,
              text: "Complaint",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintScreen(
                      outletId: result.outletId,
                      outletName: result.outletName,
                    ),
                  ),
                );
              }),
          ButtomflatButton(
              icon: Icons.assignment,
              text: "Visit",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitStart(
                      outletId: result.outletId,
                      visitDate: DateTime.now(),
                      outletName: result.outletName,
                      outletAddress: result.address,
                      outletImage: result.imagePath,
                    ),
                  ),
                );
              }),
          MapflatButton(context: context, result: result),
          ButtomflatButton(
              icon: Icons.assignment_ind,
              text: "Edit",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OutletDetail(outletId: result.outletId),
                  ),
                );
              }),
        ],
      ),
    );
  }

  TextButton ButtomflatButton({IconData icon, String text, Function func}) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
      ),
      onPressed: func,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(
            width: 1,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  TextButton MapflatButton({BuildContext context, Result result}) {
    double _rlat = 0.0;
    double _rlng = 0.0;
    try {
      _rlat = result.gpsLatitude;
      _rlng = result.gpsLongtitude;
    } catch (e) {
      _rlat = 0.0;
      _rlng = 0.0;
    }
    if (_rlat == 0.0 || _rlng == 0.00) {
      return ButtomflatButton(
          icon: Icons.wrong_location_rounded, text: "Map", func: () {});
    } else {
      return ButtomflatButton(
          icon: Icons.location_on,
          text: "Map",
          func: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutletMap(
                  outletName: result.outletName,
                  lat: _rlat,
                  lng: _rlng,
                ),
              ),
            );
          });
    }
  }
}
