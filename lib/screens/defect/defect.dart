import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/defecttrans.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/defect/components/defect_edit.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';

class Defect extends StatefulWidget {
  static String routeName = "/defect";
  String outletId;
  String outletName;

  Defect({this.outletId, this.outletName});

  @override
  _DefectState createState() => _DefectState();
}

class _DefectState extends State<Defect> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    getDefect();
    super.initState();
  }

  void getDefect() {
    imageCache.clear();

    TsemProvider()
        .getDefectTrans(outletid: widget.outletId, defectid: 'ALL')
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
        //Not exists asset in this outlet.
        setState(() {
          _nodes = [];
        });
      } else {
        setState(() {
          _nodes.addAll(value.result);
        });
      }
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
        title: DefaultControl.headerText(headText: widget.outletName),
      ),
      body: _showDefectCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DefectEdit(
                  outletId: widget.outletId, outletName: widget.outletName),
            ),
          ).then((value) {
            setState(() {
              _nodes = [];
              getDefect();
            });
          });
        },
        tooltip: 'Defect',
        child: Icon(Icons.assignment_outlined),
      ),
    );
  }

  Widget _showDefectCard() {
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
                  return itemCallCard(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemCallCard(Result item) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => ImageDialog(
                      imagePath: item.defectImage,
                    ));
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: SizeConfig.screenHeight * 0.18,
                placeholder: 'assets/images/noimage.jpg',
                image: item.defectImage,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            onTap: () {
              setState(() {
                detailClick(item);
              });
            },
            title: Text(
              item.category,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),
            ),
            subtitle: Text(
              "${item.statusname} "
              " Defect Id: ${item.id}"
              "\n${item.pmName}"
              "\n${item.defRemark} "
              "\nBatch code: ${item.batchCode == null ? "" : DateFormat('d-MM-yy').format(item.batchCode)}"
              "\nVisit date: ${item.visitDate == null ? "" : DateFormat('d-MM-yy').format(item.visitDate)}"
              "\nLast update: ${DateFormat('d-MM-yy').format(item.updateDate)}",
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  void detailClick(Result item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DefectEdit(
            defectId: item.id,
            outletId: item.outletId,
            outletName: item.outletName),
      ),
    ).then((value) {
      setState(() {
        _nodes = [];
        getDefect();
      });
    });
  }
}

class ImageDialog extends StatelessWidget {
  String imagePath;

  ImageDialog({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            width: SizeConfig.screenHeight * 0.3,
            placeholder: 'assets/images/noimage.jpg',
            image: imagePath,
          ),
        ),
      ),
    );
  }
}
