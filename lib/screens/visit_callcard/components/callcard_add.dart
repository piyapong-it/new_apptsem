import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/models/productmasterbyvisit.dart';
import 'package:tsem/provider/product_provider.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import 'package:tsem/components/msg_alert.dart';

class CallCardAdd extends StatefulWidget {
  static String routeName = "/callcardadd";

  String outletId;
  String outletName;
  DateTime visitDate;
  String visitId;
  int agendaId;

  CallCardAdd(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.visitId,
      this.agendaId});

  @override
  _CallCardAddState createState() => _CallCardAddState();
}

class _CallCardAddState extends State<CallCardAdd> {
  List<Result> _nodes = [];
  List<Result> _nodesForDisplay = [];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final editingController = TextEditingController();

  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    ProductProvider()
        .getProductMasterByVisit(visitid: widget.visitId, own: 'ALL')
        .then((value) {
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
                    var noteTitle = note.pmName.toLowerCase();
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
    bool _isChecked = nodesForDisplay.selectedPm == 1 ? true : false;

    return Card(
      margin: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                //_launchDetail(outletId: result.outletId);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(nodesForDisplay.pmName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "${nodesForDisplay.bmName} Item:${nodesForDisplay.pmId}"
                      "\nPack Type:${nodesForDisplay.pmType} Size: ${nodesForDisplay.pmSize}",
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value;
                            if (value) {
                              nodesForDisplay.selectedPm = 1;
                              detailClick(nodesForDisplay);
                            }else{
                              nodesForDisplay.selectedPm = 0;
                              deleteClick(nodesForDisplay);
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

  void detailClick(Result item) {
    VisitProvider().updateVisitCallCard(
        visitId: widget.visitId,
        agendaId: widget.agendaId,
        pmid: item.pmId,
        premas: item.premas == null ? 0 : item.premas,
        mas: item.mas == null ? 0 : item.mas,
        price: item.price == null ? 0.0 : item.price,
        stock: item.stock == null ? 0 : item.stock,
        productdate: null,
        outletid: widget.outletId,
        visitdate: widget.visitDate.toString());
  }

  void deleteClick(Result item) {
    VisitProvider().deleteVisitCallCard(
        visitId: widget.visitId,
        agendaId: widget.agendaId,
        pmid: item.pmId);
  }
}
