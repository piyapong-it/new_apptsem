import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:tsem/models/outletnearby.dart';
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/outlet_nearby_map/outlet_nearby_map_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../components/msg_alert.dart';
import './components/card_section.dart';

class OutletNearbyScreen extends StatefulWidget {
  static String routeName = "/outletnearby";

  @override
  _OutletNearbyScreenState createState() => _OutletNearbyScreenState();
}

class _OutletNearbyScreenState extends State<OutletNearbyScreen> {
  List<Result> _nodes = [];
  List<Result> _nodesForDisplay = [];
  LocationData currentLocation;

  String numberOfOutlet = "";
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final editingController = TextEditingController();

  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    _goToMe().then((value) => OutletProvider()
            .getOutletNearby(
                lat: currentLocation.latitude,
                lng: currentLocation.longitude,
                km: 1.0)
            .then((value) {
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
            numberOfOutlet = _nodesForDisplay.length.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFECDF),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Oulet nearby 1 km. (${numberOfOutlet})",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.local_offer_sharp),
              tooltip: "Map",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OutletNearbyMap(
                      outlets: _nodesForDisplay,
                      currentLocation: currentLocation,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: "Refresh",
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(seconds: 1), curve: Curves.easeInOut);
              },
            ),
          ],
        ),
        body: _nodes.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _showSearchList());
  }

  Widget _showSearchList() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _nodesForDisplay = _nodes.where((note) {
                    var noteTitle = note.outletName.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList();
                  numberOfOutlet = _nodesForDisplay.length.toString();
                });
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black26),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: Center(
              child: RefreshIndicator(
                key: _refresh,
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return CardSection(_nodesForDisplay[index]);
                  },
                  itemCount: _nodesForDisplay.length,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
    return null;
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
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
}
