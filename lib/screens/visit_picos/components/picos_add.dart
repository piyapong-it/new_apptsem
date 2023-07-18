import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/models/itemvisiteoe.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class PicosAdd extends StatefulWidget {
  static String routeName = "/picosadd";

  String outletId;
  String outletName;
  DateTime visitDate;
  String visitId;
  int agendaId;

  PicosAdd(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.visitId,
      this.agendaId});

  @override
  _EoeAddState createState() => _EoeAddState();
}

class _EoeAddState extends State<PicosAdd> {
  List<Result> _nodes = [];
  List<Result> _nodesForDisplay = [];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final editingController = TextEditingController();

  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    VisitProvider().getItemVisitEoE(
        {"P_OWN": "ALL", "P_VisitId": widget.visitId}).then((value) {
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
        print(value.result);
        _nodes.addAll(value.result);
        _nodesForDisplay = _nodes;
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });

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
        title: DefaultControl.headerText(headText: widget.outletName),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 30.0,
            ),
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
          : _showSearchList(),
    );
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
                    var noteTitle = note.pm_name.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList();
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

  Widget CardSection(Result nodesForDisplay) {
    bool _isChecked = nodesForDisplay.selected == 1 ? true : false;

    return Card(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(nodesForDisplay.pm_name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      " Item:${nodesForDisplay.pm_id}",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value;
                            if (value) {
                              nodesForDisplay.selected = 1;
                              nodesForDisplay.eoe_flag = 'Y';
                              detailClick(nodesForDisplay);
                            } else {
                              nodesForDisplay.selected = 0;
                              nodesForDisplay.eoe_flag = 'N';
                              detailClick(nodesForDisplay);
                            }
                          });
                        }),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void detailClick(Result item) async {
    final storage = new FlutterSecureStorage();
    String jdecode = await storage.read(key: JDECODE);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(widget.visitDate);
    VisitProvider().updateVisitEOEFlag({
      "VisitID": widget.visitId,
      "OutletID": widget.outletId,
      "VisitDate": formatted,
      "AgendaId": item.agenda_id,
      "AgendaGroup": 'NND',
      "EoEseq": item.eoe_seq,
      "EoEPM_ID": item.pm_id,
      "EoEImage": item.eoe_image,
      "EoEText": item.eoe_text,
      "EoEfocus": item.eoe_focus,
      "EoEflag": item.eoe_flag,
      "UpdateBy": jdecode,
    });
  }
}
