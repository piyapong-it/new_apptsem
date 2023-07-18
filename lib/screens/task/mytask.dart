import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/tasktrans.dart';
import 'package:tsem/provider/tsem_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';
import 'components/task_edit.dart';

class MyTaskScreen extends StatefulWidget {
  static String routeName = "/mytaskscreen";

  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  List<Result> _nodes = [];
  MessageAlert messageAlert = MessageAlert();

  // Default Radio Button Item
  String selectedRadio = "All";

  @override
  void initState() {
    getTask(selectedRadio);
    super.initState();
  }

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
      setState(() {
        _nodes = [];
        getTask(selectedRadio);
      });
    });
  }

  void getTask(String status) {
    imageCache.clear();

    TsemProvider().getMyTaskTrans(taskstatus: status).then((value) {
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
        //Not exists asset in this outlet.
        setState(() {
          _nodes = [];
        });
      } else {
        setState(() {
          _nodes.addAll(value.result);
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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DefaultControl.headerText(headText: "My Task"),
      ),
      body: _showTaskCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, OutletScreen.routeName).then((value) {
            setState(() {
              _nodes = [];
              getTask(selectedRadio);
            });
          });
        },
        tooltip: 'Task',
        child: Icon(Icons.assignment_outlined),
      ),
    );
  }

  Widget _showTaskCard() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text("Incomplete"),
                  leading: Radio<String>(
                    value: "Incomplete",
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      //print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text("All"),
                  leading: Radio<String>(
                    value: "All",
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      //print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return itemTaskCard(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemTaskCard(Result item) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => ImageDialog(
                      imagePath: item.resultTaskImage,
                    ));
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                width: SizeConfig.screenHeight * 0.15,
                child: Image.network(
                  item.resultTaskImage,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset('assets/images/noimage.jpg');
                  },
                ),
              ),
              // FadeInImage.assetNetwork(
              //   fit: BoxFit.cover,
              //   width: SizeConfig.screenHeight * 0.18,
              //   placeholder: 'assets/images/noimage.jpg',
              //   image: item.resultTaskImage,
              // ),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            onTap: () {
              setState(() {
                detailClick(item);
              });
            },
            title: Text(
              item.outletName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),
            ),
            subtitle: Text(
              "${item.category} "
              "\n${item.statusname} "
              "\nId: ${item.id}"
              "\nDue date: ${DateFormat('d-MM-yy').format(item.dueDate)}",
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  void detailClick(Result item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskEdit(
            taskId: item.id,
            outletId: item.outletId,
            outletName: item.outletName),
      ),
    ).then((value) {
      setState(() {
        _nodes = [];
        getTask(selectedRadio);
      });
    });
  }
}

class ImageDialog extends StatelessWidget {
  String imagePath;

  ImageDialog({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            imagePath,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
              return Image.asset('assets/images/noimage.jpg');
            },
          ),
        ),
      ),
    );
  }
}
