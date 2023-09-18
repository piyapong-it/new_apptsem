import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/district.dart';
import 'package:tsem/models/outlettype.dart';
import 'package:tsem/models/province.dart';
import 'package:tsem/models/subdistrict.dart';
import 'package:tsem/provider/address_provider.dart';
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class FormsOutletRequest extends StatefulWidget {
  static String routeName = "/FormsOutletRequest";
  const FormsOutletRequest();

  @override
  State<FormsOutletRequest> createState() => _FormsOutletRequestState();
}

class _FormsOutletRequestState extends State<FormsOutletRequest> {
  MessageAlert messageAlert = MessageAlert();
  File _image;
  String _fileName;
  final _form = GlobalKey<FormState>();
  LocationData _locationData;
  List<resProvince> itemProvince = [];
  resProvince _selectProvince = resProvince();
  List<resDistrict> itemDistrict = [];
  resDistrict _selectDistrict = resDistrict();
  List<resSubDistrict> itemSubDistrict = [];
  resSubDistrict _selectSubDistrict = resSubDistrict();
  TextEditingController _Zipcode = TextEditingController();
  TextEditingController _houseNo = TextEditingController();
  final TextEditingController _Contact = TextEditingController();
  final TextEditingController _Telphone = TextEditingController();
  final TextEditingController _Mobile = TextEditingController();
  final TextEditingController _LatLong = TextEditingController();
  List<TypeStatusResult> _nodeOutletType = [];
  List<TypeStatusResult> _nodeOutletStatus = [];
  TypeStatusResult _selectOutlateType = TypeStatusResult();
  TypeStatusResult _selectOutlateStatus = TypeStatusResult();

  @override
  void initState() {
    getProvinceData();
    getOutletType();
    getOutletStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {Navigator.pop(context)}),
          actions: [
            IconButton(
              // focusNode: saveFocusNode,
              icon: Icon(
                Icons.save,
                size: 35.0,
                color: Colors.blue,
              ),
              tooltip: "Save",
              onPressed: () {},
            ),
          ],
          title: DefaultControl.headerText(headText: "Forms New Outlet"),
        ),
        body: SafeArea(
            child: Form(
                key: _form,
                child: Container(
                    // decoration: (BoxDecoration(
                    //   color: Color.fromARGB(255, 226, 186, 159),
                    // )),
                    margin: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        _buildOutletImage(),
                        SizedBox(height: 10),
                        _showAddress(),
                        SizedBox(height: 8),
                        _showFormsOutletRequest(),
                      ],
                    ))))));
  
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
                  height: 130,
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
                    margin: EdgeInsets.only(left: 100, top: 110),
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

  Widget _showAddress() {
    return Container(
      child: Column(children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  isDense: true,
                  decoration: InputDecoration(
                      labelText: "Province",
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                  value: _selectProvince,
                  iconSize: 24,
                  items: itemProvince.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.provinceName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _selectProvince = newValue;
                    _Zipcode.text = '';
                    getDistrictData(newValue.provinceId);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  isDense: true,
                  decoration: InputDecoration(
                      labelText: "District",
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                  value: _selectDistrict,
                  iconSize: 24,
                  items: itemDistrict.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.districtName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _selectDistrict = newValue;
                    _Zipcode.text = '';
                    getSubDistrictData(newValue.districtId);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  isDense: true,
                  decoration: InputDecoration(
                      labelText: "SubDistrict",
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                  value: _selectSubDistrict,
                  iconSize: 24,
                  items: itemSubDistrict.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.subdistrictName),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _selectSubDistrict = newValue;
                    _Zipcode.text = newValue.zipCode;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
            child: Row(children: [
          Expanded(
              child: Container(
            child: Column(children: [
              TextField(
                maxLength: 255,
                controller: _houseNo,
                style: TextStyle(fontSize: 13.0),
                enabled: true,
                maxLines: 2, //or null
                decoration: InputDecoration(
                  counterText: "",
                  labelText: "houseNo Moo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ]),
          )),
        ])),
        SizedBox(height: 8),
        Container(
            child: Row(children: [
          Expanded(
              child: Container(
            child: Column(children: [
              TextField(
                maxLength: 5,
                controller: _Zipcode,
                style: TextStyle(fontSize: 13.0),
                enabled: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: "",
                  labelText: "ZipCode",
                  border: OutlineInputBorder(),
                ),
              ),
            ]),
          )),
        ])),
      ]),
    );
  }

  void getProvinceData() {
    AddressProvider().getProvince().then((value) {
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
          itemProvince = [];
          itemProvince = value.result;
          _selectProvince = itemProvince[0];
          getDistrictData(_selectProvince.provinceId);
        });
      }
    }).catchError((err) {});
  }

  void getDistrictData(provinceId) {
    AddressProvider().getDistrict(province: provinceId).then((value) async {
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
          itemDistrict = value.result;
          _selectDistrict = itemDistrict[0];
          getSubDistrictData(_selectDistrict.districtId);
        });
        setState(() {});
      }
    }).catchError((err) {});
  }

  void getSubDistrictData(districtId) {
    AddressProvider().getSubDistrict(district: districtId).then((value) async {
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
          itemSubDistrict = [];
          itemSubDistrict = value.result;
          _selectSubDistrict = itemSubDistrict[0];
        });
      }
    }).catchError((err) {});
  }

  void getPermission() async {
    if (await Permission.location.isGranted) {
      getLocation();
    } else {
      Permission.location.request();
    }
  }

  void getLocation() async {
    _locationData = await Location.instance.getLocation();
    _LatLong.text = _locationData.latitude.toString() +
        "/" +
        _locationData.longitude.toString();
  }

  Widget _showFormsOutletRequest() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Column(children: [
                    TextField(
                      maxLength: 60,
                      style: TextStyle(fontSize: 13.0),
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: "Outlet Name",
                        prefixIcon: Icon(
                          Icons.home_work_outlined,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ]),
                )),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
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
          _TextFeild(_Contact, 60, 13.0, true, TextInputType.text, 'Contact',
              Icons.account_box),
          SizedBox(height: 8),
          _TextFeild(_Telphone, 20, 13.0, true, TextInputType.number,
              'Telphone', Icons.phone),
          SizedBox(height: 8),
          _TextFeild(_Mobile, 20, 13.0, true, TextInputType.number, 'Mobile',
              Icons.phone),
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
                        labelText: "Outlet Type",
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255)),
                    isExpanded: true,
                    items: _nodeOutletType.map((TypeStatusResult value) {
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
                        labelText: "Outlet Status",
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                    isExpanded: true,
                    items: _nodeOutletStatus.map((TypeStatusResult value) {
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
        ],
      ),
    );
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
        setState(() {});
      } else {
        setState(() {
          _nodeOutletType = value.result;
          _selectOutlateType = _nodeOutletType[0];
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
        setState(() {});
      } else {
        setState(() {
          _nodeOutletStatus = value.result;
          _selectOutlateStatus = _nodeOutletStatus[1];
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

  Widget _TextFeild(
      controller, maxLength, fontSize, enabled, keyboardType, labelText, icon) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              maxLength: maxLength,
              controller: controller,
              style: TextStyle(fontSize: fontSize),
              enabled: enabled,
              keyboardType: keyboardType,
              maxLines: null,
              decoration: InputDecoration(
                counterText: "",
                labelText: labelText,
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  icon,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

