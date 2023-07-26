import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/assetmaster.dart';
import 'package:tsem/models/udc.dart';
import 'package:tsem/provider/asset_provider.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:validators/validators.dart';

import '../../../size_config.dart';

class AssetEdit extends StatefulWidget {
  String outletId;
  String qrId;
  String outletName;

  AssetEdit({@required this.outletId, this.outletName, @required this.qrId});

  @override
  _AssetEditState createState() => _AssetEditState();
}

class _AssetEditState extends State<AssetEdit> {
  List<UdcResult> _nodeCategory = [];
  List<UdcResult> _nodeStatus = [];
  UdcResult _selectStatus = UdcResult();
  UdcResult _selectCategory = UdcResult();

  Result item = Result();

  var _formKey = GlobalKey<FormState>();

  FocusNode categoryFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode snnoFocusNode = FocusNode();
  FocusNode jdenoFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();
  FocusNode quantityFocusNode = FocusNode();

  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    AssetProvider()
        .getAssetMaster(outletid: 'ALL', qrid: widget.qrId)
        .then((value) {
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
          item.assetQuantity = 1;
        });
      } else {
        setState(() {
          item = value.result[0];
          item.assetQuantity == null
              ? item.assetQuantity = 1
              : item.assetQuantity;
          getUdcStatus();
          getUdcCategory();
        });
      }
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFECDF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DefaultControl.headerText(headText: widget.outletName),
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
              saveAssetHead();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "QR code ${widget.qrId}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
              SizedBox(height: 20),
              _buildCategory(),
              SizedBox(height: 10),
              _buildAssetImage(),
              SizedBox(height: 10),
              _buildStatus(),
              SizedBox(height: 5),
              _buildSnNo(),
              SizedBox(height: 5),
              _buildJdeNo(),
              SizedBox(height: 5),
              _buildRemark(),
              SizedBox(height: 5),
              _quantity(),
            ],
          ),
        ),
      ),
    );
  }

  void saveAssetHead() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      AssetProvider()
          .updateAsset(
              outletid: widget.outletId,
              stickerid: widget.qrId,
              assetcategory: _selectCategory.udcKey,
              assetstatus: _selectStatus.udcKey,
              assetsno: item.assetSno == null ? '' : item.assetSno,
              assetjdeno:
                  item.assetJdeno == null ? '0' : item.assetJdeno.toString(),
              assetremark: item.assetRemark,
              assetquantity: item.assetQuantity)
          .then((value) => Navigator.pop(context));
    }
  }

  Widget _buildCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<UdcResult>(
          value: _selectCategory,
          items: _nodeCategory.map((UdcResult value) {
            return new DropdownMenuItem<UdcResult>(
              value: value,
              child: categoryItem(value),
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
    );
  }

  Widget _buildStatus() {
    return Row(
      children: [
        Text('Status'),
        SizedBox(
          width: 40.0,
        ),
        DropdownButton<UdcResult>(
          value: _selectStatus,
          items: _nodeStatus.map((UdcResult value) {
            return new DropdownMenuItem<UdcResult>(
              value: value,
              child: Text(value.udcDesc2),
            );
          }).toList(),
          onChanged: (UdcResult val) {
            setState(() {
              _selectStatus = val;
            });
          },
        )
      ],
    );
  }

  Widget _buildSnNo() {
    return TextFormField(
      key: Key('SNNO${item.assetSno}'),
      focusNode: snnoFocusNode,
      style: TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
        enabledBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        focusedBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        hintText: "Serial no.",
        labelText: 'Serial no.',
        icon: Icon(Icons.tag),
      ),
      initialValue: item.assetSno,
      keyboardType: TextInputType.text,
      validator: _validateSnNo,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(jdenoFocusNode);
      },
      onSaved: (value) {
        item.assetSno = value;
      },
    );
  }

  String _validateSnNo(String value) {
    if (value.isEmpty) {
      return null;
    }
  }

  Widget _buildJdeNo() {
    return TextFormField(
      key: Key('JDE${item.assetJdeno}'),
      focusNode: jdenoFocusNode,
      style: TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        hintText: "JDE number",
        labelText: 'JDE fixed asset number',
        icon: Icon(Icons.confirmation_number_outlined),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        enabledBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        focusedBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      initialValue: item.assetJdeno == null ? "" : item.assetJdeno.toString(),
      keyboardType: TextInputType.number,
      validator: _validateJdeNo,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(remarkFocusNode);
      },
      onSaved: (value) {
        item.assetJdeno = value.isEmpty ? null : int.parse(value);
      },
    );
  }

  String _validateJdeNo(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!isNumeric(value)) {
      return "Is not number";
    }
  }

  Widget _buildRemark() {
    return TextFormField(
      key: Key('REMARK${item.assetJdeno}'),
      focusNode: remarkFocusNode,
      style: TextStyle(fontSize: 14.0),
      decoration: InputDecoration(
        hintText: "Remark",
        labelText: 'Remark',
        icon: Icon(Icons.text_fields),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        enabledBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        focusedBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      maxLines: 2,
      initialValue: item.assetRemark,
      keyboardType: TextInputType.text,
      validator: _validateRemark,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(saveFocusNode);
      },
      onSaved: (value) {
        item.assetRemark = value;
      },
    );
  }

  String _validateRemark(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length > 50) {
      return "Maximum length is 50";
    }
  }

  Widget _quantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 80.0,
        ),
        RoundedIconBtn(
          icon: Icons.remove,
          press: () {
            setState(() {
              if (item.assetQuantity > 1) {
                item.assetQuantity--;
              }
            });
          },
        ),
        Container(
          child: Text(item.assetQuantity.toString(),
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
        RoundedIconBtn(
          icon: Icons.add,
          press: () {
            setState(() {
              item.assetQuantity++;
            });
          },
        ),
        SizedBox(
          width: 80.0,
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
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: press,
        child: Icon(icon),
      ),*/
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  void getUdcStatus() {
    TsemProvider().getUdc(id: '12', md: '02', key: 'ALL').then((value) {
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
          if (item.assetStatus != null) {
            _nodeStatus.forEach((element) {
              if (element.udcKey == item.assetStatus) {
                _selectStatus = element;
              }
            });
          } else {
            print("_nodeStatus");
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
    TsemProvider().getUdc(id: '12', md: '01', key: 'ALL').then((value) {
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
          if (item.assetCategory != null) {
            _nodeCategory.forEach((element) {
              if (element.udcKey == item.assetCategory) {
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

  Widget categoryItem(UdcResult result) {
    return Container(
      height: 100.0,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: FadeInImage.assetNetwork(
              fit: BoxFit.scaleDown,
              width: SizeConfig.screenHeight * 0.14,
              placeholder: 'assets/images/noimage.jpg',
              image: result.categoryImage,
            ),
          ),
          Text(result.udcDesc1)
        ],
      ),
    );
  }

  Widget _buildAssetImage() {
    return Container(
      height: 150.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: FadeInImage.assetNetwork(
              fit: BoxFit.scaleDown,
              width: SizeConfig.screenHeight * 0.4,
              placeholder: 'assets/images/noimage.jpg',
              image: _selectCategory.categoryImage == null
                  ? 'https://tap.tapb.co.th:3001/assets/noimage.jpg'
                  : _selectCategory.categoryImage,
            ),
          ),
        ],
      ),
    );
  }
}
