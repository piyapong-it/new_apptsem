import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/complainttrans.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';
import 'components/complaint_edit.dart';

class ComplaintScreen extends StatefulWidget {
  static String routeName = "/complaintscreen";
  String outletId;
  String outletName;

  ComplaintScreen({this.outletId, this.outletName});

  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    getComplaint();
    super.initState();
  }

  void getComplaint() {
    imageCache.clear();

    TsemProvider()
        .getComplaintTrans(outletid: widget.outletId, complaintid: 'ALL')
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
        title: DefaultControl.headerText(
            headText: 'iComplaint ' + widget.outletName),
      ),
      body: _showComplaintCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintEdit(
                  outletId: widget.outletId, outletName: widget.outletName),
            ),
          ).then((value) {
            setState(() {
              _nodes = [];
              getComplaint();
            });
          });
        },
        tooltip: 'Complaint',
        child: Icon(Icons.assignment_outlined),
      ),
    );
  }

  Widget _showComplaintCard() {
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
                  return itemComplaintCard(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemComplaintCard(Result item) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => ImageDialog(
                      imagePath: item.cpImage1,
                    ));
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    width: SizeConfig.screenHeight * 0.15,
                    child: Image.network(
                      item.cpImage1,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset('assets/images/noimage.jpg');
                      },
                    ),
                  ),
                )
                // FadeInImage.assetNetwork(
                //   fit: BoxFit.cover,
                //   width: SizeConfig.screenHeight * 0.18,
                //   placeholder: 'assets/images/noimage.jpg',
                //   image: item.cpImage1,
                // ),
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
              "Complaint no.  ${item.rid}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),
            ),
            subtitle: Text(
              "${item.pmName}"
              //"\nResult: ${item.finishText}"
              "\nProduction date: ${DateFormat('d-MM-yy').format(item.rDate)}"
              "\nRemark: ${item.rRemark} "
              "\nStatus: ${item.statusname} ",
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
        builder: (context) => ComplaintEdit(
            complaintId: item.rid,
            outletId: item.outletId,
            outletName: item.outletName),
      ),
    ).then((value) {
      setState(() {
        _nodes = [];
        getComplaint();
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
