import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/models/visitcallcard.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:validators/validators.dart';

class CallCardEdit extends StatefulWidget {
  Result callcard;

  CallCardEdit({this.callcard});

  @override
  _CallCardEditState createState() => _CallCardEditState();
}

class _CallCardEditState extends State<CallCardEdit> {
  var _formKey = GlobalKey<FormState>();
  DateFormat _formatter = new DateFormat('dd-MM-yyyy');
  DateTime _pickDate;
  FocusNode masFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  FocusNode stockFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();
  Result item;
  TextEditingController _remark = TextEditingController();
  

  @override
  void initState() {
    item = widget.callcard;
    _pickDate = item.productionDate;
    _remark.text = item.remark;
    if(item.mas == 0){
      item.mas = item.disCase;
    }
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
        title: DefaultControl.headerText(headText: "Call Card"),
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
              saveCallCardHead();
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
                  "${item.pmName}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
              SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Brand: ${item.bmName}   Code: ${item.pmId}",
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
              SizedBox(height: 25),
              _buildPreMas(),
              SizedBox(height: 1),
              _buildDIS(),
              SizedBox(height: 1),
              _buildTarget(),
              SizedBox(height: 1),
              _buildMas(),
              SizedBox(height: 10),
              _buildPrice(),
              SizedBox(height: 10),
              Container(
                            child: Column(children: [
                              TextField(
                                maxLength: 250,
                                controller: _remark,
                                style: TextStyle(fontSize: 13.0),
                                maxLines: 3, //or null
                                decoration: InputDecoration(
                                  labelText: "remark",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.remember_me_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ]),
                          ),
              //_buildStock(),
              //SizedBox(height: 10),
              //_buildProductDate(),
              //_buildDateForm()
            ],
          ),
        ),
      ),
    );
  }

  void saveCallCardHead() {

    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      VisitProvider()
          .updateVisitCallCard(
              visitId: item.visitId,
              agendaId: item.agendaId,
              pmid: item.pmId,
              premas: item.premas == null ? 0.0 : item.premas,
              mas: item.mas == null ? 0.0 : item.mas,
              price: item.price == null ? 0.0 : item.price,
              stock: item.stock == null ? 0.0 : item.stock,
              productdate: _pickDate == null
                  ? null
                  : DateFormat('dd-MMM-yyyy').format(_pickDate),
              outletid: item.outletId,
              visitdate: DateFormat('dd-MMM-yyyy').format(item.visitDate),
              remark: _remark != null ? _remark.text : item.remark,
              seq: item.eoeSeq)
          .then((value) => Navigator.pop(context));
    }
  }

  Widget _buildPreMas() {
    return TextFormField(
      enabled: false,
      style: TextStyle(fontSize: 25.0),
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        border: InputBorder.none,
        hintText: "Previous Sales vol",
        labelText: 'Previous Monthly sales',
        //icon: Icon(Icons.add_location),
      ),
      initialValue: item.premas.toString(),
    );
  }

  Widget _buildTarget() {
    return TextFormField(
      enabled: false,
      style: TextStyle(fontSize: 25.0),
      decoration: InputDecoration(
        contentPadding:
        new EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        border: InputBorder.none,
        hintText: "Target Sales vol",
        labelText: 'Target Monthly sales',
      ),
      initialValue: item.targetCase.toString(),
    );
  }

  Widget _buildDIS() {
    return TextFormField(
      enabled: false,
      style: TextStyle(fontSize: 25.0),
      decoration: InputDecoration(
        contentPadding:
        new EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        border: InputBorder.none,
        hintText: "DIS Sales vol",
        labelText: 'DIS sales',
        //icon: Icon(Icons.add_location),
      ),
      initialValue: item.disCase.toString(),
    );
  }

  Widget _buildMas() {
    return TextFormField(
      focusNode: masFocusNode,
      style: TextStyle(fontSize: 25.0,color: Colors.blue),
      decoration: InputDecoration(
        focusColor: Colors.blue,
        hoverColor: Colors.blue,
        fillColor: Colors.blue,
        hintText: "Monthly Sales vol",
        labelText: 'Monthly sales จำนวนลัง / เดือน',
        labelStyle: TextStyle(color: Colors.blue),
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: InputBorder.none,
        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal,width: 5.0)),
        //icon: Icon(Icons.add_location),
      ),
      initialValue: item.mas.toString(),
      keyboardType: TextInputType.number,
      validator: _validateMAS,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(priceFocusNode);
      },
      onSaved: (value) {
        item.mas = value.isEmpty ? 0.0 : double.parse(value);
      },
    );
  }

  String _validateMAS(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!isNumeric(value)) {
      return "ต้องเป็นเลขเท่านั้น";
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget _buildPrice() {
    return TextFormField(
      focusNode: priceFocusNode,
      style: TextStyle(fontSize: 25.0,color: Colors.blue),
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        //border: UnderlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        enabledBorder: InputBorder.none,
        hintText: "RSP",
        labelText: 'RSP ราคาขายหน้าร้าน/ขวด กระป๋อง',
        labelStyle: TextStyle(color: Colors.blue),
        //icon: Icon(Icons.add_location),
      ),
      initialValue: item.price.toString(),
      keyboardType: TextInputType.number,
      validator: _validatePrice,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(stockFocusNode);
      },
      onSaved: (value) {
        item.price = value.isEmpty ? 0 : double.parse(value);
      },
    );
  }

  String _validatePrice(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!isFloat(value)) {
      return "Is not number";
    }
  }

  Widget _buildStock() {
    return TextFormField(
      focusNode: stockFocusNode,
      style: TextStyle(fontSize: 25.0),
      decoration: InputDecoration(
        hintText: "Stock",
        labelText: 'Stock',
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        enabledBorder: InputBorder.none,
        //icon: Icon(Icons.add_location),
      ),
      initialValue: item.stock.toString(),
      keyboardType: TextInputType.number,
      validator: _validateStock,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(dateFocusNode);
      },
      onSaved: (value) {
        item.stock = value.isEmpty ? 0 : int.parse(value);
      },
    );
  }

  String _validateStock(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!isNumeric(value)) {
      return "Is not number";
    }
  }

  Widget _buildProductDate() {
    return TextFormField(
      focusNode: dateFocusNode,
      style: TextStyle(fontSize: 25.0),
      decoration: InputDecoration(
        hintText: "Product date",
        labelText: 'Product date',
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
        enabledBorder: InputBorder.none,
        //icon: Icon(Icons.add_location),
      ),
      initialValue: isDate(item.productionDate.toString())
          ? DateFormat('dd-MM-yyyy').format(item.productionDate)
          : "",
      keyboardType: TextInputType.number,
      validator: _validateProductDate,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(saveFocusNode);
      },
      onSaved: (value) {
        item.productionDate = value.isEmpty ? null : DateTime.parse(value);
      },
    );
  }

  String _validateProductDate(String value) {
    if (value.isEmpty) {
      return null;
    }
    print(value);
    try {
      _formatter.parse(value);
      return null;
    } catch (e) {
      print(e);
      return "Is not Date";
    }
    // if (!isDate(value)) {
    //   return "Is not Date";
    // }
  }

  Widget _buildDateForm() {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
          child: Text(
            _pickDate == null ? "" : _formatter.format(_pickDate),
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.date_range),
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: _pickDate == null ? DateTime.now() : _pickDate,
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2500))
              .then((value) {
            print('State ${value}');
            if (value != null) {
              _pickDate = value;
              print('pickdate ${_pickDate}');
            }
            setState(() {});
          });
        },
      )
    ]);
  }
}
