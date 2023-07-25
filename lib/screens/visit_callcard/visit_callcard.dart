import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visitcallcard.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/screens/visit_callcard/components/callcard_add.dart';

import '../../size_config.dart';
import 'components/callcard_edit.dart';

class VisitCallCardScreen extends StatefulWidget {
  static String routeName = "/visitcallcard";

  String outletId;
  String outletName;
  DateTime visitDate;
  String visitId;
  int agendaId;

  VisitCallCardScreen(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.visitId,
      this.agendaId});

  @override
  _VisitCallCardScreenState createState() => _VisitCallCardScreenState();
}

class _VisitCallCardScreenState extends State<VisitCallCardScreen> {
  List<Result> _nodes = [];

  MessageAlert messageAlert = MessageAlert();

  @override
  void initState() {
    getCallCard();

    super.initState();
  }

  void getCallCard() {
    VisitProvider().getVisitCallCard(visitid: widget.visitId).then((value) {
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
        //Not exists product.
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
        title: DefaultControl.headerText(
            headText: widget.outletName +
                " " +
                DateFormat('d MMM').format(widget.visitDate)),
        actions: [
          IconButton(
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
      body: _showCallCard(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CallCardAdd(
      //           visitId: widget.visitId,
      //           agendaId: widget.agendaId,
      //           outletName: widget.outletName,
      //           visitDate: widget.visitDate,
      //           outletId: widget.outletId,
      //         ),
      //       ),
      //     ).then((value) {
      //       setState(() {
      //         _nodes = [];
      //         getCallCard();
      //       });
      //     });
      //   },
      //   tooltip: 'Add Product',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _showCallCard() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return itemCallCard(_nodes[index]);
                },
                itemCount: _nodes.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemCallCard(Result item) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        VisitProvider()
            .deleteVisitCallCard(
                visitId: item.visitId, agendaId: item.agendaId, pmid: item.pmId)
            .then((value) {
          _nodes = [];
          getCallCard();
        });
      },
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Spacer(),
            SvgPicture.asset("assets/icons/Trash.svg"),
          ],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => ImageDialog(
                        imagePath: item.pmImage,
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
                  child: FadeInImage.memoryNetwork(
                      fit: BoxFit.contain,
                      width: 90,
                      height: 90,
                      placeholder: kTransparentImage,
                      // image: 'https://picsum.photos/250?image=9',
                      image: item.pmImage),
                ),
              ),
            ),
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() {
                detailClick(item);
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.pmName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${item.bmName.toString()} ${item.pmId.toString()}',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'Monthly Sales: ${item.mas.toString()} RSP: ${item.price.toString()} ',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                Text(
                  'DIS Sales: ${item.disCase.toString()} Target: ${item.targetCase.toString()} ',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ],
            ),
          )),
          // Expanded(
          //   child: Text(
          //     item.bmName,
          //     style: TextStyle(color: Colors.black),
          //   ),
          // )
        ],
      ),
    );
  }

  void saveCallCardHead() {
    VisitProvider()
        .updateVisitAgenda(
            visitId: widget.visitId,
            agendaId: widget.agendaId,
            visitStatus: "DONE")
        .then((value) => Navigator.pop(context));
  }

  void detailClick(Result item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallCardEdit(
          callcard: item,
        ),
      ),
    ).then((value) {
      setState(() {
        _nodes = [];
        getCallCard();
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
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: ExactAssetImage('assets/tamas.jpg'),
        //         fit: BoxFit.cover
        //     )
        // ),
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
