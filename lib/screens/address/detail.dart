import 'package:flutter/material.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/district.dart';
import 'package:tsem/models/province.dart';
import 'package:tsem/models/subdistrict.dart';
import 'package:tsem/screens/outlet_detail/outlet_detail.dart';
import '../../provider/address_provider.dart';
import '../sign_in/sign_in_screen.dart';

class Detail extends StatefulWidget {
  static String routeName = "/address";

  String outletid;
  String zipCode;
  String houseNo;
  String amphur;
  String tumbon;
  String provinceId;
  Detail(
      {this.outletid,
      this.zipCode,
      this.houseNo,
      this.amphur,
      this.tumbon,
      this.provinceId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  MessageAlert messageAlert = MessageAlert();
  final _form = GlobalKey<FormState>();
  List<resProvince> itemProvince = [];
  resProvince _selectProvince = resProvince();
  List<resDistrict> itemDistrict = [];
  resDistrict _selectDistrict = resDistrict();
  List<resSubDistrict> itemSubDistrict = [];
  resSubDistrict _selectSubDistrict = resSubDistrict();
  TextEditingController _Zipcode = TextEditingController();
  TextEditingController _houseNo = TextEditingController();

  @override
  void initState() {
    getProvinceData();
    _houseNo.text = widget.houseNo;
    _Zipcode.text = widget.zipCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutletDetail(outletId: widget.outletid),
              ),
            );
          },
        ),
      ),
      body: itemProvince.length == 0
          ? _buildLoadingView()
          : SafeArea(
              child: Form(
                key: _form,
                child: Container(
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      labelText: "Province",
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
                                  decoration: InputDecoration(
                                      labelText: "District",
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
                                  decoration: InputDecoration(
                                      labelText: "SubDistrict",
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
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 30, right: 30),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OutletDetail(
                                        outletId: widget.outletid,
                                        zipCode: _Zipcode.text.toString(),
                                        houseNo: _houseNo.text.toString(),
                                        amphur: _selectDistrict.districtName,
                                        tumbon:
                                            _selectSubDistrict.subdistrictName,
                                        provinceId: _selectProvince.provinceId,
                                        provinceDesc:
                                            _selectProvince.provinceName),
                                  ),
                                );
                              },
                              child: Text("Submit")),
                        ),
                      ]),
                    )),
              ),
            ),
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
          itemProvince = value.result;
          _selectProvince = itemProvince[0];
          if (widget.provinceId != null) {
            itemProvince.forEach((element) {
              if (element.provinceId == widget.provinceId) {
                _selectProvince = element;
              }
            });
          } else {
            _selectProvince = itemProvince[0];
          }
          print(_selectProvince.provinceId);
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
        itemDistrict = value.result;
        String msg = 'Not math';
        setState(() {
          if (widget.amphur != null) {
            itemDistrict.forEach((element) {
              if (element.districtName == widget.amphur) {
                msg = 'math';
                _selectDistrict = element;
              }
            });
            if (msg == 'Not math') {
              _selectDistrict = itemDistrict[0];
            }
          } else {
            _selectDistrict = itemDistrict[0];
          }
          getSubDistrictData(_selectDistrict.districtId);
        });
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
        itemSubDistrict = value.result;
        String msg = 'Not math';
        setState(() {
          if (widget.tumbon != null) {
            itemSubDistrict.forEach((element) {
              if (element.subdistrictName == widget.tumbon) {
                msg = 'math';
                _selectSubDistrict = element;
              }
            });
            if (msg == 'Not math') {
              _selectSubDistrict = itemSubDistrict[0];
            }
          } else {
            _selectSubDistrict = itemSubDistrict[0];
          }
        });
      }
    }).catchError((err) {});
  }

  _buildLoadingView() => Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Text("Loading ..."));
}
