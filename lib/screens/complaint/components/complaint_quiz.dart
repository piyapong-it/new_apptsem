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
import 'package:tsem/models/productmaster.dart' as product;
import 'package:tsem/models/udc.dart';
import 'package:tsem/provider/product_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class ComplaintQuiz extends StatefulWidget {
  static String routeName = "/complaintquiz";

  int complaintId;
  String outletId;
  String outletName;

  ComplaintQuiz({this.complaintId, this.outletId, this.outletName});

  @override
  _ComplaintQuizState createState() => _ComplaintQuizState();
}

class _ComplaintQuizState extends State<ComplaintQuiz> {
  MessageAlert messageAlert = MessageAlert();

  List<product.Result> _nodeProduct = [];
  List<UdcResult> _nodeStatus = [];
  product.Result _selectProduct = product.Result();
  UdcResult _selectStatus = UdcResult();
  DateFormat _formatter = new DateFormat('dd-MM-yyyy');
  DateTime _pickDate = DateTime.now();
  File _image1;
  File _image2;
  File _image3;
  File _image4;

  Result item = Result();

  final _formKey = GlobalKey<FormState>();

  FocusNode productFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode quizFocusNode = FocusNode();

  @override
  void initState() {
    imageCache.clear();

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
          });
        } else {
          item = await value.result[0];
          _image1 = await urlToFile(item.cpImage1);
          _image2 = await urlToFile(item.cpImage2);
          _image3 = await urlToFile(item.cpImage3);
          _image4 = await urlToFile(item.cpImage4);
          item.rDate == null ? DateTime.now() : _pickDate = item.rDate;
          setState(() {
            getProduct();
            getUdcStatus();
            _image1;
            _image2;
            _image3;
            _image4;
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
    }

    super.initState();
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
              child: Padding(
                  padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                    top: 0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProduct(),
                        SizedBox(height: 5),
                        _buildStatus(),
                        SizedBox(height: 5),
                        _buildDate(),
                        SizedBox(height: 5),
                        _buildImage1(),
                        SizedBox(height: 5),
                        _buildImage2(),
                        SizedBox(height: 5),
                        _buildImage3(),
                        SizedBox(height: 5),
                        _buildImage4(),
                        SizedBox(height: 5),
                        _buildRemark(),
                        _validateForm()
                            ? CustomButton(
                          title: 'Goto Quiz',
                          onTap: () {
                            gotoQuiz();
                          },
                        )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }

  bool _validateForm() {
    if (_image1 != null && _formKey.currentState.validate())
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
        .uploadImageTask(outletid: fileName, imageFile: image)
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
  void getProduct() {
    ProductProvider().getProductMaster(own: '0').then((value) {
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
          if (item.rpmid != null) {
            _nodeProduct.forEach((element) {
              if (element.pmId == item.rpmid) {
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
          if (item.rstatus != null) {
            _nodeStatus.forEach((element) {
              if (element.udcKey == item.rstatus) {
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

  Future<File> urlToFile(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(10)).toString() + '.jpg');
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
              onChanged: (UdcResult val) {
                setState(() {
                  _selectStatus = val;
                });
              },
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildRemark() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextFormField(
        key: Key('REMARK${item.outletId}'),
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
        initialValue: item.rRemark,
        keyboardType: TextInputType.text,
        validator: _validateRemark,
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(quizFocusNode);
        },
        onSaved: (value) {
          item.rRemark = value;
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
          Container(child: Text('Complaint date')),
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
                        lastDate: DateTime(2022))
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
