import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visiteoe.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'components/picos_add.dart';

import '../../size_config.dart';

class VisitPicosScreen extends StatefulWidget {
  static String routeName = "/visiteoe";

  String outletId;
  String outletName;
  DateTime visitDate;
  int agendaId;
  String agendaGroup;
  String visitId;

  VisitPicosScreen(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.agendaId,
      this.agendaGroup,
      this.visitId});

  @override
  _VisitEoeScreenState createState() => _VisitEoeScreenState();
}

class _VisitEoeScreenState extends State<VisitPicosScreen> {
  bool isLoading = true;
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    getVisitEOE();
     Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  void getVisitEOE() {
    VisitProvider()
        .getVisitEOE(
            outletid: widget.outletId,
            visitdate: widget.visitDate,
            group: widget.agendaGroup)
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
        // messageAlert.functAlert(
        //     context: context,
        //     message: value.message,
        //     function: () {
        //       Navigator.pushNamedAndRemoveUntil(
        //           context, OutletScreen.routeName, (route) => false);
        //     });
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DefaultControl.headerText(
            headText: widget.outletName +
                " " +
                DateFormat('d MMM').format(widget.visitDate)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              size: 35.0,
              color: Colors.blue,
            ),
            tooltip: "Save",
            onPressed: () {
              saveEoeHead();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(child: _showEOE()),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PicosAdd(
      //           visitId: widget.visitId,
      //           agendaId: widget.agendaId,
      //           outletName: widget.outletName,
      //           visitDate: widget.visitDate,
      //           outletId: widget.outletId,
      //         ),
      //       ),
      //     ).then((value) {
      //       setState(() {
      //         _nodes = [];
      //         getVisitEOE();
      //       });
      //     });
      //   },
      //   tooltip: 'Add Product',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _showEOE() {
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
                  return itemEoe(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemEoe(Result item) {
    bool _isChecked = item.eoeFlag == 'Y' ? true : false;
    Color _borderColor = item.eoeFocus == 'Y' ? Colors.red : Colors.white;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              _isChecked ? item.eoeFlag = 'Y' : item.eoeFlag = 'N';
              detailClick(item);
            });
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: _borderColor, width: 4.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                placeholder: kTransparentImage,
                // image: 'https://picsum.photos/250?image=9',
                image: item.eoeImage,
              ),
            ),
          ),
        ),
        Expanded(
            child: Text(
          item.eoeText,
          style: TextStyle(fontSize: 17.0, color: Colors.black),
        )),
        Expanded(
          child: Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                  value ? item.eoeFlag = 'Y' : item.eoeFlag = 'N';
                  detailClick(item);
                });
              }),
        )
      ],
    );
  }

  void saveEoeHead() {
    if (_nodes != null) {
      VisitProvider()
          .updateVisitAgenda(
              visitId: _nodes[0].visitId,
              agendaId: _nodes[0].agendaId,
              visitStatus: "DONE")
          .then((value) => Navigator.pop(context));
    } else {
       VisitProvider()
          .updateVisitAgenda(
              visitId: widget.visitId,
              agendaId: widget.agendaId,
              visitStatus: "DONE")
          .then((value) => Navigator.pop(context));
    }
  }

  void detailClick(Result item) {
    VisitProvider().updateVisitEoE(
        visitId: item.visitId,
        agendaId: item.agendaId,
        eoeSeq: item.eoeSeq,
        eoeFlag: item.eoeFlag);
  }
}
