import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/models/visit.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';

class VisitHistory extends StatefulWidget {
  static String routeName = "/visithistory";

  String outletId;
  String outletName;

  VisitHistory({this.outletId, this.outletName});

  @override
  _VisitHistoryState createState() => _VisitHistoryState();
}

class _VisitHistoryState extends State<VisitHistory> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.outletName);
    // SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
           leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        title:  Text(widget.outletName)
        ),
        
        body: _nodes.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _showItem());
  }

  void fetchData() {
    VisitProvider().getVisitHistory(widget.outletId).then((value) {
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
        Navigator.of(context).pop();
        messageAlert.okAlert(
            context: context,
            message: "There isn't visit history",
            title: "Visit History");
      }
      setState(() {
        _nodes.addAll(value.result);
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  Widget _showItem() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
                    child: ListTile(
                      onTap: () {},
                      leading: Text(
                        "${_nodes[index].visitType}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.blueAccent,
                            fontSize: 12.0),
                      ),
                      title: Text(
                        "${DateFormat('dd-MM-yy HH:mm').format(_nodes[index].startDate)}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${_nodes[index].smName}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 12.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        child: Text(
                          "${_nodes[index].status}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 12.0),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
