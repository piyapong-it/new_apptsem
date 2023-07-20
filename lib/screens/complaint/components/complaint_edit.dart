import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/complainttrans.dart';
import 'package:tsem/models/complaintquestion.dart' as question;
import 'package:tsem/models/complaintquiz.dart' as quiz;
import 'package:tsem/models/productmaster.dart' as product;
import 'package:tsem/models/udc.dart';
import 'package:tsem/provider/product_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/complaint/components/complaint_quiz.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../../size_config.dart';

class ComplaintEdit extends StatefulWidget {
  static String routeName = "/complaintedit";

  int complaintId;
  String outletId;
  String outletName;

  ComplaintEdit({this.complaintId, this.outletId, this.outletName});

  @override
  _ComplaintEditState createState() => _ComplaintEditState();
}

class _ComplaintEditState extends State<ComplaintEdit> {
  MessageAlert messageAlert = MessageAlert();
  PageController pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  FocusNode productFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode quizFocusNode = FocusNode();

  List<product.Result> _nodeProduct = [];
  List<UdcResult> _nodeStatus = [];
  product.Result _selectProduct = product.Result();

  List<question.Result> _nodeQuestion = [];
  List<question.Result> _nodeQuestionFilter = [];
  List<quiz.Result> _nodeQuiz = [];
  Result complainItem = Result();

  UdcResult _selectStatus = UdcResult();
  DateFormat _formatter = new DateFormat('dd-MM-yyyy');
  DateTime _pickDate = DateTime.now();
  File _image1;
  File _image2;
  File _image3;
  File _image4;

  @override
  void initState() {
    imageCache.clear();
    complainItem.rQuantity = 1;

    if (widget.complaintId != null) {
      TsemProvider()
          .getComplaintTrans(
              complaintid: widget.complaintId.toString(),
              outletid: widget.outletId)
          .then((value) async {
        if (!value.success) {
          print('Error ${value.message}');
          messageAlert.functAlert(
              context: context,
              message: value.message,
              function: () {
                Navigator.pushReplacementNamed(context, SignInScreen.routeName);
              });
        }
        if (value.result.length == 0) {
          setState(() {
            getProduct();
            getUdcStatus();
            getQuestion();
            complainItem.rQuantity = 1;
          });
        } else {
          complainItem = value.result[0];
          complainItem.rDate == null
              ? DateTime.now()
              : _pickDate = complainItem.rDate;

          _image1 = await urlToFile1(complainItem.cpImage1);
          _image2 = await urlToFile2(complainItem.cpImage2);
          _image3 = await urlToFile3(complainItem.cpImage3);
          _image4 = await urlToFile4(complainItem.cpImage4);

          setState(() {
            getProduct();
            getUdcStatus();
            getQuestion();
          });
        }
      }).catchError((err) {
        print(err);
        messageAlert.okAlert(
            context: context,
            message: "Connection error",
            title: "Please contact admin");
      });
    } else {
      getProduct();
      getUdcStatus();
      getQuestion();
      complainItem.rQuantity = 1;
    }
    super.initState();
  }

  void getProduct() {
    ProductProvider().getProductMaster(own: 'CMP').then((value) {
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
        setState(() {});
      } else {
        setState(() {
          _nodeProduct = value.result;
          if (complainItem.rpmid != null) {
            _nodeProduct.forEach((element) {
              if (element.pmId == complainItem.rpmid) {
                _selectProduct = element;
              }
            });
          } else {
            _selectProduct = _nodeProduct[0];
          }
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

  void getUdcStatus() {
    TsemProvider().getUdc(id: '14', md: '02', key: 'ALL').then((value) {
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
        setState(() {});
      } else {
        setState(() {
          _nodeStatus = value.result;
          if (complainItem.rstatus != null) {
            _nodeStatus.forEach((element) {
              if (element.udcKey == complainItem.rstatus) {
                _selectStatus = element;
              }
            });
          } else {
            _selectStatus = _nodeStatus[0];
          }
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

  void getQuestion() {
    TsemProvider().getComplaintQuestion(category: "COMPLAINT").then((value) {
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
        setState(() {});
      } else {
        setState(() {
          _nodeQuestion = value.result;
          _nodeQuestionFilter = value.result.where((note) {
            var noteStart = note.finishFlag.toUpperCase();
            return noteStart.contains("S");
          }).toList();
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
    return Scaffold(
        appBar: AppBar(
          title: DefaultControl.headerText(
              headText: 'iComplaint ' + widget.outletName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PageProduct(),
                  PagePicture(),
                  PageQuiz(),
                  PageResult()
                ],
              ),
            ),
          ),
        ));
  }

  Widget PageProduct() {
    return Padding(
        padding: EdgeInsets.only(
          right: 10,
          left: 10,
          top: 0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProduct(),
              SizedBox(height: 10),
              _buildStatus(),
              SizedBox(height: 10),
              _buildDate(),
              SizedBox(height: 10),
              _quantity(),
              SizedBox(height: 10),
              _buildRemark(),
              SizedBox(height: 20),
              CustomButton(
                title: 'Take Photo',
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    pageController.animateToPage(1,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.bounceInOut);
                  }
                  ;
                },
              )
            ],
          ),
        ));
  }

  Widget PagePicture() {
    return Padding(
        padding: EdgeInsets.only(
          right: 10,
          left: 10,
          top: 0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildImage1(),
              SizedBox(height: 5),
              _buildImage2(),
              SizedBox(height: 5),
              _buildImage3(),
              SizedBox(height: 5),
              _buildImage4(),
              SizedBox(height: 5),
              _validateForm()
                  ? CustomButton(
                      title: 'Goto Quiz',
                      onTap: () {
                        pageController.animateToPage(2,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.bounceInOut);
                      },
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ));
  }

  Widget PageQuiz() {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        top: 0,
      ),
      child: Column(
        children: [
          Text(
            'Complaint Questionnaire',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
            child: _nodeQuestionFilter != null && _nodeQuestionFilter.isNotEmpty
                ? Text(
                    _nodeQuestionFilter[0].qText,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text("Question"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
            child: _nodeQuestionFilter != null && _nodeQuestionFilter.isNotEmpty
                ? Text(
                    _nodeQuestionFilter[0].qRemark,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Divider(
            color: Colors.grey[200],
            height: 32.0,
            thickness: 2.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          Expanded(
            child: Center(
                child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return CardSection(_nodeQuestionFilter[index]);
              },
              itemCount: _nodeQuestionFilter.length,
            )),
          )
        ],
      ),
    );
  }

  Widget CardSection(question.Result item) {
    return GestureDetector(
      onTap: () {
        onTap(item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 20.0,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow,
          border: Border.all(
            color: Colors.green,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                item.aText,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTap(question.Result item) {
    quiz.Result _itemQuiz = quiz.Result();
    _itemQuiz.zid = 0;
    _itemQuiz.rid = 0;
    _itemQuiz.qid = item.qid;
    _itemQuiz.qSeq = item.qSeq;
    _itemQuiz.qText = item.qText;
    _itemQuiz.qCategory = item.qCategory;
    _itemQuiz.aid = item.aid;
    _itemQuiz.aText = item.aText;
    _itemQuiz.finishText = item.finishText;
    _nodeQuiz.add(_itemQuiz);

    if (item.finishFlag != "Y") {
      setState(() {
        _nodeQuestionFilter =
            _nodeQuestion.where((note) => note.qid == item.aNextQid).toList();
      });
    } else {
      complainItem.outletId = widget.outletId;
      complainItem.outletName = widget.outletName;
      complainItem.rstatus = _selectStatus.udcKey;
      complainItem.finishText = item.finishText;
      complainItem.rDate = _pickDate;
      complainItem.rpmid = _selectProduct.pmId;
      complainItem.cpImage1 = null;
      complainItem.cpImage2 = null;
      complainItem.cpImage3 = null;
      complainItem.cpImage4 = null;

      setState(() {
        pageController.animateToPage(3,
            duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
      });
    }
  }

  Widget PageResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        complainItem.finishText != null
            ? Text(
                //complainItem.finishText,
                "รับเรื่องเรียบร้อย \nกดปุ่ม Save complaint \nเพื่อบันทึกลงฐานข้อมูล",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 40.0),
        CustomButton(
          title: 'Save complaint',
          onTap: () {
            onFinishTap();
          },
        ),
      ],
    );
  }

  onFinishTap() async {
    String fileName;

    if (complainItem.rid == null) {
      await TsemProvider()
          .updateComplaintTrans(complaintTrans: complainItem)
          .then((value) {
        if (value.success) {
          try {
            complainItem.rid = int.parse(value.message);
          } catch (e) {
            Navigator.pop(context);
          }
        }
      });
    }

    if (_image1 != null) {
      fileName =
          complainItem.rid.toString() + '_' + complainItem.outletId + '_1';
      await _startUploading(fileName, _image1);
      complainItem.cpImage1 = 'complaint_' + fileName + '.jpg';
    }

    if (_image2 != null) {
      fileName =
          complainItem.rid.toString() + '_' + complainItem.outletId + '_2';
      await _startUploading(fileName, _image2);
      complainItem.cpImage2 = 'complaint_' + fileName + '.jpg';
    }

    if (_image3 != null) {
      fileName =
          complainItem.rid.toString() + '_' + complainItem.outletId + '_3';
      await _startUploading(fileName, _image3);
      complainItem.cpImage3 = 'complaint_' + fileName + '.jpg';
    }

    if (_image4 != null) {
      fileName =
          complainItem.rid.toString() + '_' + complainItem.outletId + '_4';
      await _startUploading(fileName, _image4);
      complainItem.cpImage4 = 'complaint_' + fileName + '.jpg';
    }

    await TsemProvider()
        .updateComplaintTrans(complaintTrans: complainItem)
        .then((value) {
      if (value.success) {
        try {
          _nodeQuiz.forEach((element) async {
            element.rid = complainItem.rid;
            await TsemProvider().updateComplaintQuiz(complaintQuiz: element);
          });
        } catch (e) {
          messageAlert.okAlert(
              context: context,
              message: "Error on save complaint",
              title: complainItem.rid.toString());
        }
      }
    });

    // messageAlert.functAlert(
    //     context: context,
    //     message: "Save complaint completed",
    //     function: () {
    //       Navigator.pop(context);
    //       Navigator.pop(context);
    //     });
    Navigator.pop(context);
  }

  bool _validateForm() {
    // if (_image1 != null && _formKey.currentState.validate())
    //   return true;
    // else
    //   return false;
    if (_image1 != null)
      return true;
    else
      return false;
  }

  // == Image1 from camera ===============================
  Widget _buildImage1() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Wrap(direction: Axis.vertical, children: [
        Container(child: Text('รูปถ่าย 1 บังคับแนบ')),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 200,
                      child: _image1 == null
                          ? Image.asset("assets/images/noimage.jpg")
                          : Image.file(
                              _image1,
                              fit: BoxFit.cover,
                            ),
                    )),
                InkWell(
                  onTap: _onAlertPress1,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.black),
                      margin: EdgeInsets.only(left: 250, top: 180),
                      child: Icon(
                        Icons.photo_camera,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void _onAlertPress1() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage1,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage1,
              ),
            ],
          );
        });
  }

  Future getCameraImage1() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image1 = image;
      Navigator.pop(context);
    });
  }

  Future getGalleryImage1() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image1 = image;
      Navigator.pop(context);
    });
  }

  // == Image2 from camera ===============================
  Widget _buildImage2() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Wrap(direction: Axis.vertical, children: [
        Container(child: Text('รูปถ่าย 2')),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 200,
                      child: _image2 == null
                          ? Image.asset("assets/images/noimage.jpg")
                          : Image.file(
                              _image2,
                              fit: BoxFit.cover,
                            ),
                    )),
                InkWell(
                  onTap: _onAlertPress2,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.black),
                      margin: EdgeInsets.only(left: 250, top: 180),
                      child: Icon(
                        Icons.photo_camera,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void _onAlertPress2() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage2,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage2,
              ),
            ],
          );
        });
  }

  Future getCameraImage2() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image2 = image;
      Navigator.pop(context);
    });
  }

  Future getGalleryImage2() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image2 = image;
      Navigator.pop(context);
    });
  }

  // == Image3 from camera ===============================
  Widget _buildImage3() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Wrap(direction: Axis.vertical, children: [
        Container(child: Text('รูปถ่าย 3')),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 200,
                      child: _image3 == null
                          ? Image.asset("assets/images/noimage.jpg")
                          : Image.file(
                              _image3,
                              fit: BoxFit.cover,
                            ),
                    )),
                InkWell(
                  onTap: _onAlertPress3,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.black),
                      margin: EdgeInsets.only(left: 250, top: 180),
                      child: Icon(
                        Icons.photo_camera,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void _onAlertPress3() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage3,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage3,
              ),
            ],
          );
        });
  }

  Future getCameraImage3() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image3 = image;
      Navigator.pop(context);
    });
  }

  Future getGalleryImage3() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image3 = image;
      Navigator.pop(context);
    });
  }

  // == Image4 from camera ===============================
  Widget _buildImage4() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Wrap(direction: Axis.vertical, children: [
        Container(child: Text('รูปถ่าย 4')),
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 200,
                      child: _image4 == null
                          ? Image.asset("assets/images/noimage.jpg")
                          : Image.file(
                              _image4,
                              fit: BoxFit.cover,
                            ),
                    )),
                InkWell(
                  onTap: _onAlertPress4,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.black),
                      margin: EdgeInsets.only(left: 250, top: 180),
                      child: Icon(
                        Icons.photo_camera,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void _onAlertPress4() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage4,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/take_picture.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage4,
              ),
            ],
          );
        });
  }

  Future getCameraImage4() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image4 = image;
      Navigator.pop(context);
    });
  }

  Future getGalleryImage4() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      image = File(pickedFile.path);
      _image4 = image;
      Navigator.pop(context);
    });
  }

  // == Image from camera ===============================
  Future<void> _startUploading(String fileName, File image) async {
    if (image == null) {
      messageAlert.okAlert(
          context: context,
          message: "Please Select a task photo",
          title: "Task Photo");
    } else {
      _uploadImage(fileName, image);
    }
  }

  void _uploadImage(String fileName, File image) {
    TsemProvider()
        .uploadImageComplaint(outletid: fileName, imageFile: image)
        .then((value) {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              print('error');
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

  // ================================= Image from camera
  Future<File> urlToFile1(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File(
        '$tempPath' + 'image1_' + (rng.nextInt(10)).toString() + '.jpg');
    // call http.get method and pass imageUrl into it to get response.
    Response response = await dio.get(
      imageUrl,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  // ================================= Image from camera
  Future<File> urlToFile2(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File(
        '$tempPath' + 'image2_' + (rng.nextInt(10)).toString() + '.jpg');
    // call http.get method and pass imageUrl into it to get response.
    Response response = await dio.get(
      imageUrl,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  // ================================= Image from camera
  Future<File> urlToFile3(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File(
        '$tempPath' + 'image3_' + (rng.nextInt(10)).toString() + '.jpg');
    // call http.get method and pass imageUrl into it to get response.
    Response response = await dio.get(
      imageUrl,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  // ================================= Image from camera
  Future<File> urlToFile4(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File(
        '$tempPath' + 'image4_' + (rng.nextInt(10)).toString() + '.jpg');
    // call http.get method and pass imageUrl into it to get response.
    Response response = await dio.get(
      imageUrl,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }

  Widget _buildProduct() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(direction: Axis.vertical, children: [
          Container(child: Text('Product')),
          DropdownButton<product.Result>(
            value: _selectProduct,
            items: _nodeProduct.map((product.Result value) {
              return new DropdownMenuItem<product.Result>(
                value: value,
                child: Text(value.pmName),
              );
            }).toList(),
            onChanged: (product.Result val) {
              setState(() {
                _selectProduct = val;
              });
            },
          )
        ]),
      ),
    );
  }

  Widget _buildStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child: Text('Status')),
            DropdownButton<UdcResult>(
              value: _selectStatus,
              items: _nodeStatus.map((UdcResult value) {
                return new DropdownMenuItem<UdcResult>(
                  value: value,
                  child: Text(value.udcDesc1),
                );
              }).toList(),
              // onChanged: (UdcResult val) {
              //   setState(() {
              //     _selectStatus = val;
              //   });
              // },
              onChanged: null,
            )
          ],
        ),
      ]),
    );
  }

  Widget _quantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.0,
        ),
        RoundedIconBtn(
          icon: Icons.remove,
          press: () {
            setState(() {
              if (complainItem.rQuantity > 1) {
                complainItem.rQuantity--;
              }
            });
          },
        ),
        SizedBox(
          width: 20.0,
        ),
        Container(
          child: Text(complainItem.rQuantity.toString(),
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          width: 20.0,
        ),
        RoundedIconBtn(
          icon: Icons.add,
          press: () {
            setState(() {
              complainItem.rQuantity++;
            });
          },
        ),
      ],
    );
  }

  Widget RoundedIconBtn({IconData icon, Null Function() press}) {
    return Container(
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 10,
            color: Color(0xFFB0B0B0).withOpacity(0.2),
          ),
        ],
      ),
      /*child: FlatButton(
        padding: EdgeInsets.zero,
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: press,
        child: Icon(icon),
      ),*/
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  Widget _buildRemark() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextFormField(
        key: Key('REMARK${complainItem.outletId}'),
        focusNode: remarkFocusNode,
        style: TextStyle(fontSize: 14.0),
        decoration: InputDecoration(
          //hintText: "Remark",
          labelText: 'Remark',
          //icon: Icon(Icons.text_fields),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          enabledBorder:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          focusedBorder:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        maxLines: 3,
        initialValue: complainItem.rRemark,
        keyboardType: TextInputType.text,
        validator: _validateRemark,
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(quizFocusNode);
        },
        onSaved: (value) {
          complainItem.rRemark = value;
        },
      )
    ]);
  }

  String _validateRemark(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length > 250) {
      return "Maximum length is 250";
    }
  }

  Widget _buildDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(direction: Axis.vertical, children: [
          Container(child: Text('Production date')),
          Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(
                    _pickDate == null ? "" : _formatter.format(_pickDate),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate:
                                _pickDate == null ? DateTime.now() : _pickDate,
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2500))
                        .then((value) {
                      //print('State ${value}');
                      if (value != null) {
                        _pickDate = value;
                        //print('pickdate ${_pickDate}');
                      }
                      setState(() {});
                    });
                  },
                ),
              ]),
          Container(child: Text('Quantity')),
        ]),
      ),
    );
  }

  Future<void> gotoQuiz() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintQuiz(
            complaintId: widget.complaintId,
            outletId: widget.outletId,
            outletName: widget.outletName,
          ),
        ),
      );
    }
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

final List<BoxShadow> boxShadow = const [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 4.0,
  ),
];
