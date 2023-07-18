import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tsem/models/outletnearby.dart';
import 'package:tsem/screens/outlet_nearby_map/components/map_section.dart';

class OutletNearbyMap extends StatefulWidget {
  static String routeName = "/outletnearbymap";

  List<Result> outlets;
  LocationData currentLocation;

  OutletNearbyMap({this.outlets, this.currentLocation});

  @override
  _OutletNearbyMapState createState() => _OutletNearbyMapState();
}

class _OutletNearbyMapState extends State<OutletNearbyMap> {
  @override
  Widget build(BuildContext context) {
    return MapSection(
        outlets: widget.outlets, currentLocation: widget.currentLocation);
  }
}
