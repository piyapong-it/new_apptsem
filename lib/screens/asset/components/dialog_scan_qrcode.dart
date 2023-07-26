import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tsem/screens/asset/components/asset_edit.dart';

class DialogScanQRCode extends StatefulWidget {
    String outletId;
  String outletName;
  DialogScanQRCode({@required this.outletId, this.outletName});

  @override
  _DialogScanQRCodeState createState() => _DialogScanQRCodeState();
}

class _DialogScanQRCodeState extends State<DialogScanQRCode> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  String code = '';

  @override
  Widget build(BuildContext context) {
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
              Navigator.pop(context);
              if (scanData.code.toString().length != 8 && scanData.code != "") {
                print(scanData.code.toString().length);
                showAlertDialog(
                    result: '${scanData.code.toString()} Length QR code',
                    context: context);
              } else if (scanData.code.toString().substring(0, 2) != '12') {
                showAlertDialog(
                    result:
                        '${scanData.code.toString().substring(0, 2)} Format QR code',
                    context: context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetEdit(
                        outletId: widget.outletId,
                        qrId: scanData.code.toString(),
                        outletName: widget.outletName),
                  ),
                );
              }
            });
          },
        ),
      );
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
