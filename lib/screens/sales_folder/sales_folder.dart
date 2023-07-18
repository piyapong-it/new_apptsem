import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/salesfolder.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sales_folder/sales_folder_view.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/screens/visit_mjp/visit_mjp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../size_config.dart';

class SalesFolderScreen extends StatefulWidget {
  static String routeName = "/salesfolder";

  @override
  _SalesFolderScreenState createState() => _SalesFolderScreenState();
}

class _SalesFolderScreenState extends State<SalesFolderScreen> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();
  final Dio _dio = Dio();
  String urlPDFPath = "";
  double loadingPercent = 0.0;
  bool loadingFinish = true;

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
          title: Text('Sales Documents',
              style: TextStyle(color: Colors.black)),
        ),
        body: _buildChild());
  }

  Widget _buildChild() {
    if (_nodes.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (loadingFinish) {
        return _showAgenda();
      } else {
        return _showDownloadProgress();
      }
    }
  }

  Widget _showDownloadProgress() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: loadingPercent,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  backgroundColor: Colors.grey,
                  strokeWidth: 15,
                ),
                Center(
                  child: _textProgress(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textProgress() {
    if (loadingPercent == 1) {
      return Icon(
        Icons.done,
        color: Colors.green,
        size: 56,
      );
    } else {
      return Text(
        '${(loadingPercent * 100).toStringAsFixed(0)+'%'}',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 24),
      );
    }
  }

  Widget _showAgenda() {
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
                      onTap: () {
                        _launchURL(_nodes[index].fileUrl,_nodes[index].fileTitle);
                      },
                      leading: leadIcon(),
                      title: Text(
                        "${_nodes[index].fileTitle}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 17.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${_nodes[index].fileSubTitle}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Container(
                        width: 80.0,
                        child: Text(
                          "${_nodes[index].fileGroupName}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 14.0),
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

  void _launchURL(String salesFolderUrl,String textTitle) async {
    final size = 200.0;

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Column(children: [
    //       Dialog(
    //         child: new Container(
    //           width: size,
    //           height: size,
    //           color: Colors.grey[200],
    //           child: Center(
    //             child: new SizedBox(
    //               height: 50.0,
    //               width: 50.0,
    //               child: new CircularProgressIndicator(
    //                 value: null,
    //                 strokeWidth: 7.0,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Text(loadingPercent)
    //     ]);
    //   },
    // );
    // if (await canLaunch(salesFolderUrl)) {
    //   await launch(
    //     salesFolderUrl,
    //     forceSafariVC: false,
    //     forceWebView: false,
    //     enableJavaScript: true,
    //     enableDomStorage: true,
    //   );
    // } else {
    //   throw 'Could not launch $salesFolderUrl';
    // }
    setState(() {
      loadingFinish = false;
    });

    getFileFromUrl(salesFolderUrl).then((f) {
      setState(() {
        loadingFinish = true;

        urlPDFPath = f.path;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalesFolderView(folderUrl: urlPDFPath,textTitle: textTitle,),
          ),
        );
      });
    });
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      //print(url);
      Response response = await _dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      var bytes = response.data;
      var dir = await getTemporaryDirectory();
      String fullPath = dir.path + "/salesfolder.pdf";

      File file = File(fullPath);

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      print(e);
      throw Exception("Error opening the file");
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        loadingPercent = (received / total);
      });
    }
  }

  void fetchData() {
    TsemProvider().getSalesFolder().then((value) {
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
            message: "There isn't Sales document",
            title: "Please contact admin");
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

  Widget leadIcon() {
    return Container(
      height: 42,
      width: 43,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green)),
      child: Icon(
        Icons.play_arrow,
        color: Colors.green,
      ),
    );
  }
}
