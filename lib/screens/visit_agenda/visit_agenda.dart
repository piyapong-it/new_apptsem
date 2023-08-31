import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visitagenda.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/asset/asset_master.dart';
import 'package:tsem/screens/defect/defect.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/screens/task/task.dart';
import 'package:tsem/screens/visit_callcard/visit_callcard.dart';
import 'package:tsem/screens/visit_eoe/visit_eoe.dart';
import 'package:tsem/screens/visit_mjp/visit_mjp.dart';
import 'package:tsem/screens/visit_picos/visit_picos.dart';

import '../../size_config.dart';

class VisitAgendaScreen extends StatefulWidget {
  static String routeName = "/visitagenda";

  String outletId;
  String outletName;
  DateTime visitDate;

  VisitAgendaScreen({
    this.outletId,
    this.visitDate,
    this.outletName,
  });

  @override
  _VisitAgendaScreenState createState() => _VisitAgendaScreenState();
}

class _VisitAgendaScreenState extends State<VisitAgendaScreen> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: DefaultControl.headerText(headText: widget.outletName),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                size: 35.0,
                color: Colors.blue,
              ),
              tooltip: "Save",
              onPressed: () {
                saveHead();
              },
            ),
          ],
        ),
        body: _nodes.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _showAgenda());
  }

  Widget _showAgenda() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Text(
            "Plan on ${DateFormat('d/MMM/yy').format(widget.visitDate)}  ",
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          Text(
            "Visit on ${DateFormat('d/MMM/yy H:mm').format(DateTime.now())}  ",
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              launchEOE(_nodes[index]);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: leadIcon(_nodes[index].status),
                                  //title: Text(_nodes[index].agendaGroup),
                                  title: Text(
                                    "${_nodes[index].agendaName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                        fontSize: 17.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    "${_nodes[index].status}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ],
                            )),
                      ],
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

  void launchEOE(Result result) {
    switch (result.agendaGroup) {
      case 'CALLCARD':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VisitCallCardScreen(
                outletId: result.outletid,
                outletName: widget.outletName,
                visitDate: result.visitDate,
                visitId: result.visitId,
                agendaId: result.agendaId,
              ),
            ),
          ).then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;

      case 'NND':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VisitEoeScreen(
                outletId: result.outletid,
                outletName: widget.outletName,
                visitDate: result.visitDate,
                agendaId: result.agendaId,
                agendaGroup: result.agendaGroup,
                visitId: result.visitId,
              ),
            ),
          ).then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;

      case 'PICOS':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VisitPicosScreen(
                outletId: result.outletid,
                outletName: widget.outletName,
                visitDate: result.visitDate,
                agendaId: result.agendaId,
                agendaGroup: result.agendaGroup,
              ),
            ),
          ).then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;
      case 'ASSET':
        {
          VisitProvider()
              .updateVisitAgenda(
                  visitId: result.visitId,
                  agendaId: result.agendaId,
                  visitStatus: "DONE")
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssetMaster(
                        outletId: result.outletid,
                        outletName: widget.outletName,
                      ),
                    ),
                  ))
              .then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;
      case 'DEFECT':
        {
          VisitProvider()
              .updateVisitAgenda(
                  visitId: result.visitId,
                  agendaId: result.agendaId,
                  visitStatus: "DONE")
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Defect(
                        outletId: result.outletid,
                        outletName: widget.outletName,
                      ),
                    ),
                  ))
              .then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;

      case 'TASK':
        {
          VisitProvider()
              .updateVisitAgenda(
                  visitId: result.visitId,
                  agendaId: result.agendaId,
                  visitStatus: "DONE")
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskScreen(
                        outletId: result.outletid,
                        outletName: widget.outletName,
                      ),
                    ),
                  ))
              .then((value) {
            setState(() {
              _nodes = [];
              fetchData();
            });
          });
        }
        break;

      default:
        {}
        break;
    }
  }

  void fetchData() {
    VisitProvider()
        .getVisitAgenda(outletid: widget.outletId, visitdate: widget.visitDate)
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
        Navigator.popUntil(
            context, ModalRoute.withName(VisitMjpScreen.routeName));
        messageAlert.okAlert(
            context: context,
            message: "This outlet type don't have agenda",
            title: "Please contact admin");
      }
      setState(() {
        _nodes.addAll(value.result);
        autoSaveHead();
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  Widget leadIcon(String status) {
    bool isDone = false;
    status == 'DONE' ? isDone = true : isDone = false;

    return Container(
      height: 42,
      width: 43,
      decoration: BoxDecoration(
          color: isDone ? Colors.green : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green)),
      child: Icon(
        Icons.play_arrow,
        color: isDone ? Colors.white : Colors.green,
      ),
    );
  }

  void saveHead() {
    bool _isAllcompleted = true;

    for (var i = 0; i < _nodes.length; i++) {
      if (_nodes[i].status != 'DONE') {
        _isAllcompleted = false;
      }
    }

    if (_isAllcompleted) {
      //print('visit id = ${_nodes[0].visitId}');
      VisitProvider()
      //เพิ่มส่งวันที่ไปด้วย
          .updateVisit(visitId: _nodes[0].visitId, visitStatus: "DONE", OultetID: '', Date: '')
          .then((value) => 
          
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new VisitMjpScreen())));
    } else {
      messageAlert.okAlert(
          context: context,
          message: "All Agenda are not done",
          title: "Please complete all agenda");
    }
  }

  void autoSaveHead() {
    bool _isAllcompleted = true;

    for (var i = 0; i < _nodes.length; i++) {
      if (_nodes[i].status != 'DONE') {
        _isAllcompleted = false;
      }
    }
    if (_isAllcompleted) {
      VisitProvider()
          .updateVisit(visitId: _nodes[0].visitId, visitStatus: "DONE" , OultetID: '', Date: '');
    }
  }

}
