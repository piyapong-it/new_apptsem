import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/outlets.dart';
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/outlet_census/components/map_census_section.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class OutletCensusMap extends StatefulWidget {
  static String routeName = "/outletcensus";

  @override
  _OutletCensusMapState createState() => _OutletCensusMapState();
}

class _OutletCensusMapState extends State<OutletCensusMap> {
  List<Result> _nodes = [];
  List<Result> _nodesForDisplay = [];
  LocationData currentLocation;
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    _goToMe().then((value) => OutletProvider().getMapOutlet().then((value) {
          if (!value.success) {
            print('message ${value.message}');
            messageAlert.functAlert(
                context: context,
                message: value.message,
                function: () {
                  Navigator.pushReplacementNamed(
                      context, SignInScreen.routeName);
                });
          }
          if (value.result.length == 0) {
            messageAlert.functAlert(
                context: context,
                message: value.message,
                function: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (route) => false);
                });
          }
          setState(() {
            _nodes.addAll(value.result);
            _nodesForDisplay = _nodes;
          });
        }).catchError((err) {
          print(err);
          messageAlert.okAlert(
              context: context,
              message: "Connection error",
              title: "Please contact admin");
        }));

    super.initState();
  }

  Future _goToMe() async {
    currentLocation = await getCurrentLocation();
  }

  Future<LocationData> getCurrentLocation() async {
    try {
      return await Location.instance.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : MapCensusSection(
            outlets: _nodesForDisplay, currentLocation: currentLocation);
  }
}
