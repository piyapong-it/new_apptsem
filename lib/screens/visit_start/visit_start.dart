import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tsem/components/default_button.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/visit_agenda/visit_agenda.dart';

import '../../size_config.dart';

class VisitStart extends StatefulWidget {
  static String routeName = "/visitstart";

  String outletId;
  String outletName;
  String outletImage;
  String outletAddress;
  DateTime visitDate;

  VisitStart(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.outletImage,
      this.outletAddress});

  @override
  _VisitStartState createState() => _VisitStartState();
}

class _VisitStartState extends State<VisitStart> {
  LocationData currentLocation;
  String lat = "0.0";
  String lng = "0.0";
  bool finishFlag = false;

  @override
  void initState() {
    _goToMe().then((value) {
      lat = currentLocation.latitude.toString();
      lng = currentLocation.longitude.toString();
    }).catchError((onError) {
      lat = "0.0";
      lng = "0.0";
    }).whenComplete(() {
      setState(() {
        finishFlag = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFFFFECDF),
        //elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(""),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    widget.outletImage,
                    height: SizeConfig.screenHeight * 0.18,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    widget.outletName,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    widget.outletAddress,
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Text(
                    "Plan date ${DateFormat('d MMM yy').format(widget.visitDate)}",
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    "Visit date ${DateFormat('d MMM yy H:mm').format(DateTime.now())}",
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    'Latitude ${lat}',
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    'Longtitude ${lng}',
                    style: TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.10),
                  finishFlag
                      ? DefaultButton(
                          text: "Start visit",
                          press: () {
                            createVisitRecord();
                          },
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();

    // Use this if want to allow turn off GSP still can visit
    //
    // bool serviceStatus = await location.serviceEnabled();
    // if (serviceStatus) {
    //   return await location.getLocation();
    // } else {
    //   // service not enabled, restricted or permission denied
    // }

    // Use this if want to not allow turn off GSP if off cannot visit
    try {
       return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    currentLocation = await getCurrentLocation();
  }

  void createVisitRecord() {
    MessageAlert messageAlert = MessageAlert();

    VisitProvider()
        .insertVisit(
            outletId: widget.outletId,
            visitDate: widget.visitDate,
            lat: lat,
            lng: lng)
        .then((value) {
      if (value.success) {
        if (value.message == 'Record exists') {
          // messageAlert.okAlert(
          //     context: context, message: value.message, title: "Visit");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new VisitAgendaScreen(
                      outletId: widget.outletId,
                      visitDate: widget.visitDate,
                      outletName: widget.outletName)));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new VisitAgendaScreen(
                      outletId: widget.outletId,
                      visitDate: widget.visitDate,
                      outletName: widget.outletName)));
        }
      } else {
        messageAlert.okAlert(
            context: context, message: value.message, title: "Error");
      }
    }).catchError((e) {
      print(e);
      messageAlert.okAlert(
          context: context, message: e.toString(), title: "Error");
    });
    ;
  }
}
