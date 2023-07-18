import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/tasktrans.dart';
import 'package:tsem/models/udc.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class TaskEdit extends StatefulWidget {
  static String routeName = "/taskedit";

  int taskId;
  String outletId;
  String outletName;

  TaskEdit({this.taskId, this.outletId, this.outletName});

  @override
  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  MessageAlert messageAlert = MessageAlert();

  List<UdcResult> _nodeCategory = [];
  List<UdcResult> _nodeStatus = [];

  UdcResult _selectStatus = UdcResult();
  UdcResult _selectCategory = UdcResult();

  Result item = Result();

  final _formKey = GlobalKey<FormState>();

  FocusNode categoryFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode dueDateFocusNode = FocusNode();
  FocusNode completeDateFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();

  File _image;

  @override
  void initState() {
    imageCache.clear();

    if (widget.taskId != null) {
      TsemProvider()
          .getTaskTrans(
              taskid: widget.taskId.toString(), outletid: widget.outletId)
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
            getUdcStatus();
            getUdcCategory();
          });
        } else {
          item = await value.result[0];
          _image = await urlToFile(item.resultTaskImage);
          setState(() {
            getUdcStatus();
            getUdcCategory();
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
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: DefaultControl.headerText(headText: widget.outletName),
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
                saveTaskHead();
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
                        _buildTaskImage(),
                        SizedBox(height: 10),
                        _buildCategory(),
                        SizedBox(height: 5),
                        _buildStatus(),
                        SizedBox(height: 5),
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
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);

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
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

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
          message: "Please Select a task photo",
          title: "Task Photo");
    } else {
      _uploadImage(fileName, _image);
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
          if (item.taskStatus != null) {
            _nodeStatus.forEach((element) {
              if (element.udcKey == item.taskStatus) {
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
    TsemProvider().getUdc(id: '14', md: '01', key: 'ALL').then((value) {
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
        print('Test Category');
        setState(() {
          _nodeCategory = value.result;
          if (item.taskCategory != null) {
            _nodeCategory.forEach((element) {
              if (element.udcKey == item.taskCategory) {
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

  Widget _buildTaskImage() {
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
                    height: 200,
                    child: _image == null
                        ? Image.asset("assets/images/noimage.jpg")
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  )),
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
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 10.0),
        child: Row(
          children: [
            Column(
              //direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
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
            )
          ],
        ));
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
        initialValue: item.taskRemark,
        keyboardType: TextInputType.text,
        validator: _validateRemark,
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(saveFocusNode);
        },
        onSaved: (value) {
          item.taskRemark = value;
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

  Future<void> saveTaskHead() async {
    String fileName;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (widget.taskId == null) {
        await TsemProvider()
            .updateTask(
                taskid: null,
                outletid: widget.outletId,
                taskcategory: _selectCategory.udcKey,
                taskstatus: _selectStatus.udcKey,
                duedate: DateTime.now(),
                completedate: DateTime.now(),
                taskimage: null,
                taskremark: item.taskRemark)
            .then((value) {
          if (value.success) {
            try {
              widget.taskId = int.parse(value.message);
            } catch (e) {
              Navigator.pop(context);
            }
          }
        });
      }

      if (_image != null) {
        fileName = widget.taskId.toString() + '_' + widget.outletId;
        await _startUploading(fileName);
        await TsemProvider()
            .updateTask(
                taskid: widget.taskId.toString(),
                outletid: widget.outletId,
                taskcategory: _selectCategory.udcKey,
                taskstatus: _selectStatus.udcKey,
                duedate: DateTime.now(),
                completedate: DateTime.now(),
                taskimage: 'task_' + fileName + '.jpg',
                taskremark: item.taskRemark)
            .then((value) => Navigator.pop(context));
      } else {
        print('_image null ${_image}');
        Navigator.pop(context);
      }
    }
  }
}
