import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tsem/models/outlets.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCensusSection extends StatefulWidget {
  List<Result> outlets;
  LocationData currentLocation;

  MapCensusSection({this.outlets, this.currentLocation});

  @override
  _MapCensusSectionState createState() => _MapCensusSectionState();
}

class _MapCensusSectionState extends State<MapCensusSection> {
  static const CameraPosition _initMap = CameraPosition(
    target: LatLng(13.7462463, 100.5325515),
    zoom: 20,
  );
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> allMarkers = [];

  BitmapDescriptor mapMarker;

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.outlets.length; i++) {
      allMarkers.add(Marker(
          markerId: MarkerId(widget.outlets[i].outletId.toString()),
          position: LatLng(widget.outlets[i].gpsLatitude,
              widget.outlets[i].gpsLongtitude),
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              widget.outlets[i].marketsSquare == 'MSO' ?
              BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue
          ),
          infoWindow: InfoWindow(
              title: widget.outlets[i].outletName,
              snippet: "${widget.outlets[i].address} ${widget.outlets[i].city} ${widget.outlets[i].province} ",
            onTap: () => _openOnGoogleMapApp(widget.outlets[i].gpsLatitude,
                widget.outlets[i].gpsLongtitude)
          ),

          // onTap: () => _openOnGoogleMapApp(widget.outlets[i].gpsLatitude,
          //     widget.outlets[i].gpsLongtitude)
      ));
    }

    return Scaffold(
        //  floatingActionButton: _buildTrackingButton(),
        appBar: AppBar(title: Text('Map'), actions: [
          // IconButton(
          //     onPressed: () {
          //       _controller.future.then(
          //         (value) => value.animateCamera(
          //           CameraUpdate.newLatLngZoom(_initMap.target, 15),
          //         ),
          //       );
          //     },
          //     icon: Icon(Icons.pin_drop)),
        ]),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: _initMap,
        // initialCameraPosition: CameraPosition(
        //   target: LatLng(widget.currentLocation.latitude,
        //       widget.currentLocation.longitude), //กำหนดพิกัดเริ่มต้นบนแผนที่
        //   zoom: 10, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
        // ),
        markers: Set.from(allMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
