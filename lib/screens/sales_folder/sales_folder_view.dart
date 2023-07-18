import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class SalesFolderView extends StatefulWidget {
  static String routeName = "/salesfolderview";

  String folderUrl;
  String textTitle;

  SalesFolderView({this.folderUrl, this.textTitle});

  @override
  _SalesFolderViewState createState() => _SalesFolderViewState();
}

class _SalesFolderViewState extends State<SalesFolderView> {
  MessageAlert messageAlert = MessageAlert();
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.textTitle,
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PDFView(
              filePath: widget.folderUrl,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onError: (e) {
                print(e);
              },
              onRender: (_pages) {
                setState(() {
                  print("Ready render");
                  _totalPages = _pages;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (int page, int total) {
                setState(() {});
              },
              onPageError: (page, e) {},
            ),
            !pdfReady
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Offstage()
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _currentPage > 0
              ?
              // FloatingActionButton.extended(
              //     backgroundColor: Colors.red,
              //     label: Text("Go to ${_currentPage - 1}"),
              //     onPressed: () {
              //       _currentPage -= 1;
              //       _pdfViewController.setPage(_currentPage);
              //     },
              //   )
              ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.navigate_before)),
                      onTap: () {
                        _currentPage -= 1;
                        _pdfViewController.setPage(_currentPage);
                      },
                    ),
                  ),
                )
              : Offstage(),
          SizedBox(width: 10,),
          _currentPage < _totalPages
              ?
              // FloatingActionButton.extended(
              //   backgroundColor: Colors.green,
              //   label: Text(">>"),
              //   onPressed: () {
              //     _currentPage += 1;
              //     _pdfViewController.setPage(_currentPage);
              //   },
              // )
              ClipOval(
                  child: Material(
                    color: Colors.blue, // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.navigate_next_outlined)),
                      onTap: () {
                        _currentPage += 1;
                        _pdfViewController.setPage(_currentPage);
                      },
                    ),
                  ),
                )
              : Offstage(),
        ],
      ),
    );
  }
}
