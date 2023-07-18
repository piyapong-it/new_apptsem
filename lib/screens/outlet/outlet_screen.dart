import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/constants.dart';
import 'package:tsem/models/outlets.dart';
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../components/msg_alert.dart';
import './components/card_section.dart';

class OutletScreen extends StatefulWidget {
  static String routeName = "/outlet";

  @override
  _OutletScreenState createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  List<Result> _nodes = [];
  List<Result> _nodesForDisplay = [];

  String numberOfOutlet = "";
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final editingController = TextEditingController();

  MessageAlert messageAlert = MessageAlert();
   final _storage = FlutterSecureStorage();
  String department;

  @override
  void initState() {
    getOutlet();
     _readDepartment();
    super.initState();
  }
    Future<Null> _readDepartment() async {
    department = await _storage.read(key: DEPARTMENT);
    setState(() {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFECDF),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
               Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (route) => false);
            },
          ),
          title: DefaultControl.headerText(
              headText: "My oulet (${numberOfOutlet})"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: "Refresh",
              onPressed: () {
                // _scrollController.animateTo(0,
                //     duration: Duration(seconds: 1), curve: Curves.easeInOut);
                setState(() {
                  _nodes = [];
                  getOutlet();
                });
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
        // image: DecorationImage(
        //   image: AssetImage("assets/images/bg.png"),
        //   fit: BoxFit.cover,
        // ),
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
                    return CardSection(_nodesForDisplay[index], department);
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
    setState(() {
      _nodes = [];
      getOutlet();
    });
    return null;
  }

  void getOutlet() {
    OutletProvider().getMyOutlet().then((value) {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
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
    });
  }
}
