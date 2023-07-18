import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tsem/models/outletnearby.dart';

class MapSection extends StatelessWidget {
  List<Result> outlets;
  LocationData currentLocation;

  MapSection({this.outlets,this.currentLocation});

  Completer<GoogleMapController> _controller = Completer();
  List<Marker> allMarkers = [];

  @override
  Widget build(BuildContext context) {

    for (var i = 0; i < outlets.length; i++) {
      allMarkers.add(Marker(
          markerId: MarkerId(outlets[i].outletId.toString()),
          position: LatLng(outlets[i].gpsLatitude,
              outlets[i].gpsLongtitude),
          draggable: true,
          infoWindow: InfoWindow(
              title: outlets[i].outletName,
              snippet: outlets[i].outletName),
          onTap: (){}
      ));
    }

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude), //กำหนดพิกัดเริ่มต้นบนแผนที่
          zoom: 16, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
        ),
        markers: Set.from(allMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
