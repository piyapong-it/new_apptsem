import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visiteoe.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

import '../../size_config.dart';

class VisitPicosScreen extends StatefulWidget {
  static String routeName = "/visiteoe";

  String outletId;
  String outletName;
  DateTime visitDate;
  int agendaId;
  String agendaGroup;
  String visitId;

  VisitPicosScreen(
      {this.outletId,
      this.visitDate,
      this.outletName,
      this.agendaId,
      this.agendaGroup,
      this.visitId});

  @override
  _VisitEoeScreenState createState() => _VisitEoeScreenState();
}

class _VisitEoeScreenState extends State<VisitPicosScreen> with TickerProviderStateMixin {
 TabController _tabController;
@override
  void initState() {

    super.initState();
     _tabController = TabController(length: 3, vsync: this);
  }


 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
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
          title: DefaultControl.headerText(
            headText: widget.outletName +
                " " +
                DateFormat('d MMM').format(widget.visitDate)),
          bottom: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: 'Connect',
                icon: Icon(Icons.connect_without_contact),
              ),
              Tab(
                text: 'Guide',
                icon: Icon(Icons.book_outlined),
              ),
              Tab(
                text: 'Convert',
                icon: Icon(Icons.sync_alt_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  SizedBox(height: 10),
                ],
              ))),
            Center(
              child: Text("Guide"),
            ),
             Center(
              child: Text("Convert"),
            ),
          ],
        ),
      ),
    );
  }

}
