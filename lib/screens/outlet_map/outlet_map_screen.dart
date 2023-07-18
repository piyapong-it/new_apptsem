import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tsem/screens/outlet_map/components/map_section.dart';

class OutletMap extends StatefulWidget {
  static String routeName = "/outletmap";

  double lat;
  double lng;
  String outletName;

  OutletMap({this.outletName, this.lat, this.lng});

  @override
  _OutletMapState createState() => _OutletMapState();
}

class _OutletMapState extends State<OutletMap> {
  BitmapDescriptor _markerIcon;

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);

    return MapSection(
        outletName: widget.outletName, lat: widget.lat, lng: widget.lng);
  }

  Future _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      ImageConfiguration configuration = ImageConfiguration();
      // BitmapDescriptor bmpd = await BitmapDescriptor.fromAssetImage(
      //     configuration, 'assets/images/tap_icon.png');
      setState(() {
        // _markerIcon = bmpd;
      });
    }
  }
}
