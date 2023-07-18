import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/outletdetail.dart' as outlet;
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/models/outlettype.dart';
import 'package:tsem/provider/address_provider.dart';
import 'package:tsem/models/outletall.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';

import '../../constants.dart';
import '../address/detail.dart';

class OutletDetail extends StatefulWidget {
  static String routeName = "/outletdetail";

  String outletId;
  String zipCode;
  String houseNo;
  String amphur;
  String tumbon;
  String provinceId;
  String provinceDesc;

  OutletDetail(
      {this.outletId,
      this.zipCode,
      this.houseNo,
      this.amphur,
      this.tumbon,
      this.provinceId,
      this.provinceDesc});

  @override
  _OutletDetailState createState() => _OutletDetailState();
}

class _OutletDetailState extends State<OutletDetail>
    with WidgetsBindingObserver {
  MessageAlert messageAlert = MessageAlert();
  List<TypeStatusResult> _nodeOutletType = [];
  List<TypeStatusResult> _nodeOutletStatus = [];
  List<OutletAllResult> _nodeOutletAll = [];

  outlet.Result item = outlet.Result();

  final _formKey = GlobalKey<FormState>();

  FocusNode outletTypeFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  File _image;
  String _fileName;

  final TextEditingController _Address = TextEditingController();
  final TextEditingController _LatLong = TextEditingController();
  final TextEditingController _Telphone = TextEditingController();
  final TextEditingController _Mobile = TextEditingController();
  final TextEditingController _Zipcode = TextEditingController();
  final TextEditingController _houseNo = TextEditingController();
  final TextEditingController _Amphur = TextEditingController();
  final TextEditingController _Tumbon = TextEditingController();
  final TextEditingController _buyFrom1 = TextEditingController();
  final TextEditingController _buyFrom2 = TextEditingController();
  String _province;
  String _provinceDesc;
  TypeStatusResult _selectOutlateType = TypeStatusResult();
  TypeStatusResult _selectOutlateStatus = TypeStatusResult();

  bool _isLoading = false;
  LocationData _locationData;

  @override
  void initState() {
    imageCache.clear();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await this.getOutletDetailData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.outletName == null ? "" : item.outletName,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.black)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, OutletScreen.routeName, (route) => false)
                }),
        actions: [
          IconButton(
            focusNode: saveFocusNode,
            icon: Icon(
              Icons.save,
              size: 35.0,
              color: Colors.blue,
            ),
            tooltip: "Save",
            onPressed: () {
              saveOutletDetail();
              saveDetailOutl();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    _buildOutletImage(),
                    SizedBox(height: 10),
                    // _buildText(
                    //     "outletId : ${item.outletId}", 14.0, FontWeight.normal),
                    // SizedBox(height: 10),
                    _buildText(item.outletName, 16.0, FontWeight.bold),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Column(children: [
                              TextField(
                                controller: _Address,
                                style: TextStyle(fontSize: 13.0),
                                readOnly: true,
                                maxLines: 3, //or null
                                decoration: InputDecoration(
                                  labelText: "Address",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.home_work_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ]),
                          )),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(
                                      outletid: widget.outletId.toString(),
                                      zipCode: widget.zipCode != null
                                          ? widget.zipCode
                                          : item.zipCode.toString(),
                                      houseNo: widget.houseNo != null
                                          ? widget.houseNo
                                          : item.addr1.toString(),
                                      amphur: widget.amphur != null
                                          ? widget.amphur
                                          : item.addr5.toString(),
                                      tumbon: widget.tumbon != null
                                          ? widget.tumbon
                                          : item.addr6.toString(),
                                      provinceId: widget.provinceId != null
                                          ? widget.provinceId
                                          : item.provinceId.toString()),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit_outlined),
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Column(children: [
                              TextField(
                                maxLength: 60,
                                controller: _LatLong,
                                style: TextStyle(fontSize: 13.0),
                                readOnly: true,
                                maxLines: null, //or null
                                decoration: InputDecoration(
                                  counterText: "",
                                  labelText: "Lat. / Long.",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.map,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ]),
                          )),
                          IconButton(
                            onPressed: () {
                              getPermission();
                            },
                            icon: Icon(Icons.edit_location_alt),
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              maxLength: 20,
                              controller: _Telphone,
                              style: TextStyle(fontSize: 13.0),
                              enabled: true,
                              keyboardType: TextInputType.number,
                              maxLines: null, //or null
                              decoration: InputDecoration(
                                counterText: "",
                                labelText: "Telphone",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              maxLength: 20,
                              controller: _Mobile,
                              style: TextStyle(fontSize: 13.0),
                              enabled: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: "",
                                labelText: "Mobile",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField(
                              value: _selectOutlateType,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blueAccent,
                              ),
                              iconSize: 30,
                              decoration: InputDecoration(
                                  labelText: "Outlate Type",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Color.fromARGB(255, 255, 255, 255)),
                              isExpanded: true,
                              items:
                                  _nodeOutletType.map((TypeStatusResult value) {
                                return DropdownMenuItem<TypeStatusResult>(
                                  value: value,
                                  child: Text(
                                    value.udc_desc1,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectOutlateType = newValue;
                                  print(_selectOutlateType.udc_desc1);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<TypeStatusResult>(
                              value: _selectOutlateStatus,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blueAccent,
                              ),
                              iconSize: 30,
                              decoration: InputDecoration(
                                  labelText: "Outlate Status",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white),
                              isExpanded: true,
                              items: _nodeOutletStatus
                                  .map((TypeStatusResult value) {
                                return DropdownMenuItem<TypeStatusResult>(
                                  value: value,
                                  child: Text(
                                    value.udc_desc1,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectOutlateStatus = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _buyFrom1,
                              style: TextStyle(fontSize: 14.0),
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Buy From1",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _buyFrom2,
                              style: TextStyle(fontSize: 14.0),
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Buy From2",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])))),
    );
  }

  void getPermission() async {
    if (await Permission.location.isGranted) {
      getLocation();
    } else {
      Permission.location.request();
    }
  }

  void getLocation() async {
    setState(() {
      _isLoading = true;
    });
    _locationData = await Location.instance.getLocation();

    _LatLong.text = _locationData.latitude.toString() +
        "/" +
        _locationData.longitude.toString();

    setState(() {
      _isLoading = false;
    });
  }

  void getOutletDetailData() {
    OutletProvider()
        .getOutletByOutletId(outletid: widget.outletId)
        .then((value) async {
      print(value);
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
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        item = await value.result[0];
        _image = await urlToFile(item.outletImage);
        setState(() {
          _isLoading = true;
          _Telphone.text = item.telephone.toString();
          _Mobile.text = item.mobile.toString();
          _buyFrom1.text = item.buyFrom1;
          _buyFrom2.text = item.buyFrom2;
          _houseNo.text = item.addr1;
          _Amphur.text = item.addr5;
          _Tumbon.text = item.addr6;
          _Zipcode.text = item.zipCode;
          _Address.text = item.addr1 +
              "\n" +
              item.addr6 +
              " " +
              item.addr5 +
              "\n" +
              item.province +
              " " +
              item.zipCode;
          _LatLong.text =
              item.gpsLatitude.toString() + "/" + item.gpsLongtitude.toString();
        });
        print(widget.houseNo);
        if (widget.provinceId != null) {
          _Address.text = '';
        }
        if (widget.houseNo != null) {
          setState(() {
            _houseNo.text = widget.houseNo;
            _Address.text += _houseNo.text + "\n";
          });
        }
        if (widget.tumbon != null) {
          setState(() {
            _Tumbon.text = widget.tumbon == '─' ? '' : widget.tumbon;
            _Address.text += _Tumbon.text + ' ';
          });
        }
        if (widget.amphur != null) {
          setState(() {
            _Amphur.text = widget.amphur == '─' ? '' : widget.amphur;
            _Address.text += _Amphur.text + "\n";
          });
        }
        if (widget.provinceId != null) {
          setState(() {
            _province = widget.provinceId;
            _provinceDesc = widget.provinceDesc;
            _Address.text += widget.provinceDesc + ' ';
          });
        }
        if (widget.zipCode != null) {
          setState(() {
            _Zipcode.text = widget.zipCode;
            _Address.text += _Zipcode.text;
          });
        }
        await this.getOutletType();
        await this.getOutletStatus();
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

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(10)).toString() + '.jpg');
    Response response = await dio.get(
      imageUrl,
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

  void getOutletType() {
    OutletProvider()
        .getOutletTypeStatus(Sys_Id: '01', Sys_Md: '05', Sys_Enbled: '1')
        .then((value) async {
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
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        setState(() {
          _isLoading = true;
          _nodeOutletType = value.result;
          print(item.outletTypeId);
          if (item.outletTypeId != null) {
            _nodeOutletType.forEach((element) {
              if (element.udc_key == item.outletTypeId) {
                _selectOutlateType = element;
              }
            });
          } else {
            _selectOutlateType = _nodeOutletType[0];
          }
          _isLoading = false;
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

  void getOutletStatus() {
    OutletProvider()
        .getOutletTypeStatus(Sys_Id: '01', Sys_Md: '09', Sys_Enbled: '1')
        .then((value) async {
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
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        setState(() {
          _isLoading = true;
          _nodeOutletStatus = value.result;
          if (item.statusId != null) {
            _nodeOutletStatus.forEach((element) {
              if (element.udc_key == item.statusId) {
                _selectOutlateStatus = element;
              }
            });
          } else {
            _selectOutlateStatus = _nodeOutletStatus[0];
          }
          _isLoading = false;
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

  void getOutletAll() {
    OutletProvider().getOutletAll().then((value) async {
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
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        setState(() {
          _isLoading = true;
          _nodeOutletAll = value.result;
          _isLoading = false;
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

  Widget _buildText(String ptext, double fs, FontWeight fw) {
    return Text(ptext == null ? "" : ptext,
        style: TextStyle(fontSize: fs, fontWeight: fw));
  }

  Widget _buildOutletImage() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: SizedBox(
                  height: 150,
                  child: _image == null
                      ? Image.asset("assets/images/noimage.jpg")
                      : Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              InkWell(
                onTap: _onAlertPress,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Color.fromARGB(255, 26, 4, 4)),
                    margin: EdgeInsets.only(left: 200, top: 130),
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
    );
  }

  void _onAlertPress() async {
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
                onPressed: getGalleryImage,
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
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  Future<void> saveDetailOutl() async {
    final storage = new FlutterSecureStorage();
    String _fristname = await storage.read(key: FRISTNAME);
    final initData = {
      "lat": _locationData != null
          ? _locationData.latitude.toString()
          : item.gpsLatitude.toString(),
      "long": _locationData != null
          ? _locationData.longitude.toString()
          : item.gpsLongtitude.toString(),
      "buyfrom1": item.buyFromCode1,
      "buyfrom2": item.buyFromCode2,
      "status": _selectOutlateStatus != null
          ? _selectOutlateStatus.udc_desc1.toString()
          : item.statusDesc,
      "outlEnabled": _selectOutlateStatus != null
          ? _selectOutlateStatus.udc_key
          : item.statusId,
      "outlTel": _Telphone != null ? _Telphone.text.toString() : item.telephone,
      "outlMobile": _Mobile != null ? _Mobile.text.toString() : item.mobile,
      "type": _selectOutlateType != null
          ? _selectOutlateType.udc_key.toString()
          : item.outletTypeId.toString(),
      "typeDesc": _selectOutlateType != null
          ? _selectOutlateType.udc_desc1.toString()
          : item.outletType.toString(),
      "provinceID":
          widget.provinceId != null ? widget.provinceId : item.provinceId,
      "outlZipcode": widget.zipCode != null ? widget.zipCode : item.zipCode,
      "address": widget.houseNo != null ? widget.houseNo : item.addr1,
      "amphur": widget.amphur != null ? widget.amphur : item.addr5,
      "tumbon": widget.tumbon != null ? widget.tumbon : item.addr6,
      "outlId": item.outletId,
      "UpdateBy": _fristname
    };
    UpdateOutlet(initData);
  }

  void UpdateOutlet(Object data) {
    OutletProvider().UpdateOutlet(data: data).then((value) async {
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
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, OutletScreen.routeName, (route) => false);
            });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutletScreen(),
          ),
        );
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  Future<void> saveOutletDetail() async {
    String fileName;

    if (_image != null) {
      fileName = widget.outletId;
      _startUploading(fileName);
    } else {
      print('_image null ${_image}');
      Navigator.pop(context);
    }
  }

  Future<void> _startUploading(String fileName) async {
    if (_image == null) {
      messageAlert.okAlert(
          context: context,
          message: "Please Select a profile photo",
          title: "Defect Photo");
    } else {
      _uploadImage(fileName, _image);
    }
  }

  void _uploadImage(String fileName, File image) {
    TsemProvider()
        .uploadImageOutlet(outletid: fileName, imageFile: image)
        .then((value) {
      if (!value.success) {
        print('message ${value.message}');
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              print('error');
              //Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      } else {
        _fileName = value.message.toString();
        if (_fileName != null) {
          TsemProvider().updateOutletImage(
              outletid: widget.outletId, imagepath: _fileName);
          // .then((value) =>
          // Navigator.pop(context)
          // );
        }
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
  Future getCameraImage() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      image = File(pickedFile.path);
      _image = image;
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    File image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      image = File(pickedFile.path);
      _image = image;
      Navigator.pop(context);
    });
  }
}
