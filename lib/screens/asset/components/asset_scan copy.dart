import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsem/components/default_button.dart';
import 'package:tsem/components/default_control.dart';

import '../../../size_config.dart';
import 'asset_edit.dart';

class AssetScan extends StatefulWidget {
  String outletId;
  String outletName;

  AssetScan({@required this.outletId, this.outletName});

  @override
  _AssetScanState createState() => _AssetScanState();
}

class _AssetScanState extends State<AssetScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          //backgroundColor: Color(0xFFFFECDF),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: DefaultControl.headerText(headText: widget.outletName)),
      body: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  _buildScan(context: context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildScan({BuildContext context}) => Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "assets/images/ic_scan_qrcode.png",
              width: SizeConfig.screenHeight * 0.30,
              height: SizeConfig.screenHeight * 0.30,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.15,
            ),
            // RaisedButton(
            //   color: Colors.blue,
            //   textColor: Colors.white,
            //   child: Text("SCAN"),
            //   onPressed: (){
            //     scanQRCode(context: context);
            //   } ,
            // ),
            DefaultButton(
                text: "SCAN",
                press: () {
                  scanQRCode(context: context);
                }),
          ],
        ),
      );

  Future scanQRCode({BuildContext context}) async {

      var result = await BarcodeScanner.scan();

  print(result.type); // The result type (barcode, cancelled, failed)
  print(result.rawContent); // The barcode content
  print(result.format); // The barcode format (as enum)
  print(result.formatNote); 
    /*try {
      ScanResult barcode = await BarcodeScanner.scan();
      if (barcode.rawContent.toString().length != 8 &&
          barcode.rawContent != "") {
        print(barcode.rawContent.toString().length);
        showAlertDialog(
            result: '${barcode.rawContent.toString()} Length QR code',
            context: context);
      } else if (barcode.rawContent.toString().substring(0, 2) != '12') {
        showAlertDialog(
            result:
                '${barcode.rawContent.toString().substring(0, 2)} Format QR code',
            context: context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssetEdit(
                qrId: barcode.rawContent.toString(),
                outletId: widget.outletId,
                outletName: widget.outletName),
          ),
        );
      }
    } on PlatformException catch (exception) {
      if (exception.code == BarcodeScanner.cameraAccessDenied) {
        showAlertDialog(
            result: 'not grant permission to open the camera',
            context: context);
      } else {
        print('Unknown error: $exception');
      }
    } catch (exception) {
      print('Unknown error: $exception');
    }
    */
  }

  showAlertDialog({BuildContext context, String result}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Result"),
          content: Text(result),
          actions: <Widget>[
            /*FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            )*/
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        );
      },
    );
  }
}
