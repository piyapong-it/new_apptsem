import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/assetmaster.dart';
import 'package:tsem/provider/asset_provider.dart';
import 'package:tsem/screens/asset/components/asset_edit.dart';
import 'package:tsem/screens/asset/components/asset_scan.dart';
import 'package:tsem/screens/asset/components/dialog_scan_qrcode.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';

class AssetMaster extends StatefulWidget {
  static String routeName = "/assetmaster";
  String outletId;
  String outletName;

  AssetMaster({this.outletId, this.outletName});

  @override
  _AssetMasterState createState() => _AssetMasterState();
}

class _AssetMasterState extends State<AssetMaster> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    getAssetMaster();
    super.initState();
  }

  void getAssetMaster() {
    AssetProvider()
        .getAssetMaster(outletid: widget.outletId, qrid: 'ALL')
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
      body: _showAssetCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showScanQRCode(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AssetScan(
          //         outletId: widget.outletId, outletName: widget.outletName),
          //     // builder: (context) => AssetEdit(
          //     //     qrId: '12000007',
          //     //     outletId: widget.outletId, outletName: widget.outletName),
          //   ),
          // ).then((value) {
          //   setState(() {
          //     _nodes = [];
          //     getAssetMaster();
          //   });
          // });
        },
        tooltip: 'Scan QR',
        child: Icon(Icons.qr_code_rounded),
      ),
    );
  }

  void _showScanQRCode(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => DialogScanQRCode(
          outletId: widget.outletId, outletName: widget.outletName),
    );
  }

  Widget _showAssetCard() {
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
                      imagePath: item.categoryImage,
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
                width: SizeConfig.screenHeight * 0.15,
                placeholder: 'assets/images/noimage.jpg',
                image: item.categoryImage,
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
              item.categoryName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
            subtitle: Text(
              "SN: ${item.assetSno} "
              "\nQR id: ${item.stickerId}"
              "\nStatus: ${item.statusNameT}"
              "\nQuantity: ${item.assetQuantity}"
              "\nLast update: ${DateFormat('d-MM-yy').format(item.updateDate)}",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
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
        builder: (context) => AssetEdit(
            qrId: item.stickerId,
            outletId: item.outletId,
            outletName: item.outletName),
      ),
    ).then((value) {
      setState(() {
        _nodes = [];
        getAssetMaster();
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
