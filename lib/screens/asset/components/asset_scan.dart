// import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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
    final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  String code = '';

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
                  _buildScanDialog(context: context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

 
Widget _buildScanDialog ({BuildContext context}) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(code),
            SizedBox(height: 12),
            Stack(alignment: Alignment.center, children: [
              _buildQRView(),
              Container(
                color: Colors.red,
                width: double.infinity,
                height: 1,
              )
            ]),
            Container(
              margin: EdgeInsets.only(top: 12),
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('close'),
              ),
            )
          ],
        ),
      ),
    );
  }

 SizedBox _buildQRView() => SizedBox(
        height: 300,
        child: QRView(
          key: _qrKey,
          onQRViewCreated: (QRViewController controller) {
            controller.scannedDataStream.listen((scanData) {
              controller.stopCamera();
              setState(() {
                code = scanData.code;
              });
            });
          },
        ),
      );
  Future scanQRCode({BuildContext context}) async {

    
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
