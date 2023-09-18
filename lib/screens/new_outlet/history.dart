import 'package:flutter/material.dart';
import 'package:tsem/components/default_control.dart';
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/provider/outlet_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/new_outlet/components/card_history.dart';
import 'package:tsem/screens/new_outlet/components/forms_outletRequset.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class HistoryNewOutlet extends StatefulWidget {
  static String routeName = "/historynewoutlet";
  const HistoryNewOutlet();

  @override
  State<HistoryNewOutlet> createState() => _HistoryNewOutletState();
}

class _HistoryNewOutletState extends State<HistoryNewOutlet> {
  List _history = [];
  List _historyForDisplay = [];
  String numberOfOutletReq = "";
  MessageAlert messageAlert = MessageAlert();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final SearchController = TextEditingController();

  @override
  void initState() {
    getNewOutletRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (route) => false)
                }),
        title: DefaultControl.headerText(
            headText: "New Outlet Request (Total ${numberOfOutletReq})"),
      ),
      body: _history.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _showHistoryOutlet(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormsOutletRequest(),
            ),
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _showHistoryOutlet() {
    return Container(
      decoration: (BoxDecoration(
        color: Color(0xFFFFECDF),
      )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _historyForDisplay = _history.where((note) {
                    var noteTitle = note.cmOutlName.toLowerCase();
                    return noteTitle.contains(text);
                  }).toList();
                  numberOfOutletReq = _historyForDisplay.length.toString();
                });
              },
              controller: SearchController,
              decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black26),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: Center(
              child: RefreshIndicator(
                key: _refresh,
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return CardHistory(_historyForDisplay[index]);
                  },
                  itemCount: _historyForDisplay.length,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    print("_handleRefresh");
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _history = [];
      getNewOutletRequest();
    });
    return null;
  }

  void getNewOutletRequest() {
    OutletProvider().getOutletRequest().then((value) {
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
                  context, HomeScreen.routeName, (route) => false);
            });
      }

      setState(() {
        _history.addAll(value.result);
        _historyForDisplay = _history;
        numberOfOutletReq = _historyForDisplay.length.toString();
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }
}
