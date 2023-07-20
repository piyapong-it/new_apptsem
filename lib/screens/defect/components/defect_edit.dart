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
import 'package:tsem/models/productmaster.dart' as product;
import 'package:tsem/models/defecttrans.dart' as defect;
import 'package:tsem/models/udc.dart';
import 'package:tsem/provider/product_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class DefectEdit extends StatefulWidget {
  static String routeName = "/defectedit";

  int defectId;
  String outletId;
  String outletName;

  DefectEdit({this.defectId, this.outletId, this.outletName});

  @override
  _DefectEditState createState() => _DefectEditState();
}

class _DefectEditState extends State<DefectEdit> {
  MessageAlert messageAlert = MessageAlert();

  List<UdcResult> _nodeCategory = [];
  List<UdcResult> _nodeStatus = [];
  List<product.Result> _nodeProduct = [];
  UdcResult _selectStatus = UdcResult();
  UdcResult _selectCategory = UdcResult();
  product.Result _selectProduct = product.Result();

  defect.Result item = defect.Result();

  final _formKey = GlobalKey<FormState>();

  DateFormat _formatter = new DateFormat('dd-MM-yyyy');
  DateTime _pickDate = DateTime.now();

  FocusNode categoryFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode productFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  File _image;

  @override
  void initState() {
    imageCache.clear();

    if (widget.defectId != null) {
      TsemProvider()
          .getDefectTrans(
              defectid: widget.defectId.toString(), outletid: widget.outletId)
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
          setState(() {
            getUdcStatus();
            getUdcCategory();
            getProduct();
          });
        } else {
          item = await value.result[0];

          //print(item.defectImage);
          _image = await urlToFile(item.defectImage);

          //Batch code date
          item.batchCode == null ? DateTime.now() : _pickDate = item.batchCode;
          //print(item.batchCode);

          setState(() {
            getUdcStatus();
            getUdcCategory();
            getProduct();
            _image;
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
      getUdcStatus();
      getUdcCategory();
      getProduct();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: DefaultControl.headerText(
              headText:
                  'Defect product at ${widget.outletName} ${widget.defectId}'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                saveDefectHead();
              },
            ),
          ],
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
                        _buildDefectImage(),
                        SizedBox(height: 5),
                        _buildCategory(),
                        SizedBox(height: 5),
                        _buildStatus(),
                        SizedBox(height: 5),
                        _buildProduct(),
                        SizedBox(height: 5),
                        _buildBatchCode(),
                        //SizedBox(height: 5),
                        _buildRemark(),
                      ],
                    ),
                  )),
            ),
          ),
        ));
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
        .uploadImageDefect(outletid: fileName, imageFile: image)
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
      }

      // messageAlert.okAlert(
      //     context: context, message: value.profileUrl, title: "Defect Photo");
      // Navigator.pop(context);
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void getUdcStatus() {
    TsemProvider().getUdc(id: '13', md: '02', key: 'ALL').then((value) {
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
          if (item.defStatus != null) {
            _nodeStatus.forEach((element) {
              if (element.udcKey == item.defStatus) {
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

  void getUdcCategory() {
    TsemProvider().getUdc(id: '13', md: '01', key: 'ALL').then((value) {
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
          _nodeCategory = value.result;
          if (item.defCategory != null) {
            _nodeCategory.forEach((element) {
              if (element.udcKey == item.defCategory) {
                _selectCategory = element;
              }
            });
          } else {
            _selectCategory = _nodeCategory[0];
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
          if (item.defPmid != null) {
            _nodeProduct.forEach((element) {
              if (element.pmId == item.defPmid) {
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

  Future<File> urlToFile(String imageUrl) async {
    Dio dio = Dio();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    //Directory tempDir = await getApplicationDocumentsDirectory();
    // Clean temp image file
    // final localFile = File('${tempDir.path}.jpg');
    // await localFile.delete();

    // if (tempDir.existsSync()) {
    //   print('temp dir ${tempDir}');
    //   tempDir.deleteSync(recursive: true);
    //   print('delete');
    // }

    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    //print('imageUrl ${imageUrl}');
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(10)).toString() + '.jpg');
    //File file = await new File('$tempPath' + '.jpg');
    //print(file);
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
    //http.Response response = await http.get(imageUrl);
    // write bodyBytes received in response to file.
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    //await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Widget _buildDefectImage() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    //width: 150,
                    height: 200,
                    child: _image == null
                        ? Image.asset("assets/images/noimage.jpg")
                        //: Image.network(item.defectImage) ,
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  )),
              // CircleAvatar(
              //   backgroundImage: _image == null
              //       ? AssetImage("assets/images/noimage.jpg")
              //       : FileImage(_image),
              //   radius: 80.0,
              // ),
              InkWell(
                onTap: _onAlertPress,
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
          //Text('Product Defect', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text('Category'),
              DropdownButton<UdcResult>(
                value: _selectCategory,
                items: _nodeCategory.map((UdcResult value) {
                  return new DropdownMenuItem<UdcResult>(
                    value: value,
                    child: Text(value.udcDesc1),
                  );
                }).toList(),
                //isExpanded: true,
                onChanged: (UdcResult val) {
                  setState(() {
                    _selectCategory = val;
                  });
                },
              )
            ],
          ),
        ));
  }

  Widget _buildStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          direction: Axis.vertical,
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
      ),
    );
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
        initialValue: item.defRemark,
        keyboardType: TextInputType.text,
        validator: _validateRemark,
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(saveFocusNode);
        },
        onSaved: (value) {
          item.defRemark = value;
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

  Future<void> saveDefectHead() async {
    String fileName;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (widget.defectId == null) {
        await TsemProvider()
            .updateDefect(
                defectid: null,
                outletid: widget.outletId,
                defectcategory: _selectCategory.udcKey,
                defectstatus: _selectStatus.udcKey,
                defectimage: null,
                pmid: _selectProduct.pmId,
                batchcode: DateFormat('yyyy-MM-dd').format(_pickDate),
                defectremark: item.defRemark)
            .then((value) {
          if (value.success) {
            try {
              widget.defectId = int.parse(value.message);
            } catch (e) {
              Navigator.pop(context);
            }
          }
        });
      }

      if (_image != null) {
        fileName = widget.defectId.toString() + '_' + widget.outletId;
        await _startUploading(fileName);
        await TsemProvider()
            .updateDefect(
                defectid: widget.defectId.toString(),
                outletid: widget.outletId,
                defectcategory: _selectCategory.udcKey,
                defectstatus: _selectStatus.udcKey,
                defectimage: 'defect_' + fileName + '.jpg',
                pmid: _selectProduct.pmId,
                batchcode: DateFormat('yyyy-MM-dd').format(_pickDate),
                defectremark: item.defRemark)
            .then((value) => Navigator.pop(context));
      } else {
        //print('_image null ${_image}');
        Navigator.pop(context);
      }
    }
  }

  Widget _buildBatchCode() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(direction: Axis.vertical, children: [
          Container(child: Text('Batch code')),
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
}
