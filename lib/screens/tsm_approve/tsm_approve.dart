import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tsem/components/default_control.dart';

import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/constants.dart';
import 'package:tsem/models/VisitPlans.dart';
import 'package:tsem/models/extendbyasm.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/provider/approve_provider.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/screens/visit_start/visit_start.dart';

class TsmApprove extends StatefulWidget {
  static String routeName = "/tsmapprove";
  TsmApprove();

  @override
  State<TsmApprove> createState() => _TsmApproveState();
}

class _TsmApproveState extends State<TsmApprove> with TickerProviderStateMixin {
  MessageAlert messageAlert = MessageAlert();
  List<Result> _nodes =[];
  List _selectedEvents;
  DateTime _selectedDay = DateTime.now();
  bool menuApprRej = false;
  DateTime DateRefresh = DateTime.now();
  DateTime _selectdDayPlan = DateTime.now();

  Map<DateTime, List<dynamic>> _events;
  CalendarController _calendarController;
  AnimationController _animationController;
  List<ResultAsm> _extendItem = [];
  ResultAsm _seleteSE = ResultAsm();
  Map<DateTime, List<dynamic>> _groupEvents(List<Result> events) {
    Map<DateTime, List<dynamic>> mapFetch = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.startDate.year, event.startDate.month, event.startDate.day, 12);
      if (mapFetch[date] == null) mapFetch[date] = [];
      mapFetch[date].add(event);
    });
    return mapFetch;
  }

  void getVisitPlan(visitPlan_date, jde_code) async {
    VisitProvider()
        .getVisitPlans(visitPlan_date.toString(), jde_code)
        .then((value) {
      if (!value.success) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        setState(() {
          _events = {};
          _selectedEvents = [];
          _nodes = [];
          menuApprRej = false;
        });
      } else {
        setState(() {
          _nodes = [];
          _events = {};
          _selectedEvents = [];
          menuApprRej = false;
          menuApprRej = value.result[0].status == "POST";
          _nodes.addAll(value.result);
          _events = _groupEvents(_nodes);
        });
        List<Result> filteredPlanDate = _nodes
            .where((plan) =>
                plan.startDate.toString().substring(0, 11) ==
                _selectdDayPlan.toString().substring(0, 11))
            .toList();
        _onDaySelected(_selectdDayPlan, filteredPlanDate);
      }
    }).catchError((err) {
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  void _onDaySelected(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedEvents = events;
      _selectdDayPlan = day;
    });
  }

  @override
  void initState() {
    menuApprRej = false;
    _events = {};
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final _storage = FlutterSecureStorage();
      String _jdecode = await _storage.read(key: JDECODE);
      await this.getExtendByAsm(_jdecode.toString());
    });
    super.initState();
  }

  void getExtendByAsm(asmCode) {
    ApproveProvider().getExtendByAsm(asmCode).then((value) async {
      if (!value.success) {
        messageAlert.functAlert(
            context: context,
            message: value.message,
            function: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            });
      }
      if (value.result.length == 0) {
        setState(() {
          _events = {};
          _selectedEvents = [];
          _nodes = [];
          _extendItem = [];
        });
      } else {
        final storage = new FlutterSecureStorage();
        String seApprove = await storage.read(key: APPROVED);
        String planApprove = await storage.read(key: PLANAPPROVED);
        setState(() async {
          _extendItem = [];
          _extendItem.addAll(value.result);
          if (seApprove != null) {
            _extendItem.forEach((element) {
              if (element.SalesCode == seApprove) {
                _seleteSE = element;
              }
            });
            storage.delete(key: APPROVED);
            print(_seleteSE.SalesCode);
            print(DateTime.parse(planApprove));
            _selectedDay = DateTime.parse(planApprove);
            _selectdDayPlan = DateTime.parse(planApprove);
            DateRefresh = DateTime.parse(planApprove);
            storage.delete(key: PLANAPPROVED);
            await getVisitPlan(_selectdDayPlan, _seleteSE.SalesCode);
          } else {
            _seleteSE = _extendItem[0];
            await getVisitPlan(_selectdDayPlan, _seleteSE.SalesCode);
          }
        });
      }
    }).catchError((err) {
      setState(() {});
      // messageAlert.okAlert(
      //     context: context,
      //     message: "getExtendByAsm error",
      //     title: "Please contact admin");
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFECDF),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.routeName, (route) => false)
                  }),
          title: DefaultControl.headerText(headText: "Visit Plan Approve"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 30.0,
                color: Colors.black,
              ),
              tooltip: "Refresh",
              onPressed: () {
                setState(() {
                  _nodes = [];
                  _events = {};
                  _selectedEvents = [];
                  menuApprRej = false;
                  getVisitPlan(DateRefresh, _seleteSE.SalesCode);
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _DropdownButtonExample(),
                _buildTableCalendarWithBuilders(),
                const SizedBox(height: 8.0),
                const SizedBox(height: 8.0),
                Expanded(
                    child: _nodes.length == 0
                        ? Text("no data available ....")
                        : _buildEventList()),
              ],
            ),
          ),
        ),
        floatingActionButton: _getFAB());
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 20),
      backgroundColor: Colors.blue.shade600,
      visible: menuApprRej,
      // visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.red.shade600,
            onTap: () {
              UpdateStatus("REJECTED");
            },
            label: 'Reject',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18.0),
            labelBackgroundColor: Colors.red.shade600),
        SpeedDialChild(
            child: Icon(
              Icons.approval_outlined,
              color: Colors.white,
              size: 30,
            ),
            backgroundColor: Colors.greenAccent.shade700,
            onTap: () {
              UpdateStatus("APPROVED");
            },
            label: 'Approve',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18.0),
            labelBackgroundColor: Colors.greenAccent.shade700)
      ],
    );
  }

  Widget _DropdownButtonExample() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          filled: true,
          fillColor: Colors.greenAccent.shade200,
        ),
        dropdownColor: Colors.greenAccent.shade100,
        value: _seleteSE,
        onChanged: (newValue) {
          setState(() async {
            _seleteSE = newValue;
            await getVisitPlan(_selectdDayPlan, _seleteSE.SalesCode);
          });
        },
        items: _extendItem.map<DropdownMenuItem>((ResultAsm value) {
          return DropdownMenuItem<ResultAsm>(
            value: value,
            child: Text(
              value.SalesName,
              style: TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      //locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      initialSelectedDay: _selectedDay,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
        holidayStyle: TextStyle().copyWith(color: Colors.red[600]),
        todayColor: Colors.orange,
        selectedColor: Theme.of(context).primaryColor,
        todayStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              //color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.deepOrange[300],
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            //color: Colors.amber[400],
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (DateTime date, events, eventnotuse) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    DateTime startDate = DateTime.now();
    DateTime chkDate = last;

    if (startDate.isAfter(chkDate)) {
      menuApprRej = false;
    } else {
      // menuApprRej = true;
    }
    DateRefresh = first;
    getVisitPlan(first, _seleteSE.SalesCode);
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    bool isDone = false;
    events[0].status == 'APPROVED' ? isDone = true : isDone = false;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? isDone
                ? Colors.green[400]
                : Colors.orange[500]
            : _calendarController.isToday(date)
                ? isDone
                    ? Colors.green[400]
                    : Colors.orange[500]
                : isDone
                    ? Colors.green[400]
                    : Colors.orange[500],
      ),
      width: 20.0,
      height: 30.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.4),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                  leading: leadIcon(event.status),
                  title: Text(
                    "${event.outletName}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  subtitle: Text(
                    "${event.outletKey}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0),
                  )),
            ),
          )
          .toList(),
    );
  }

  UpdateStatus(status) async {
    final storage = new FlutterSecureStorage();
    String jdecode = await storage.read(key: JDECODE);
    ApproveProvider().UpdateStatusAndSendMail(
        _selectdDayPlan.toString(), _seleteSE.SalesCode.toString(), status);
    storage.write(key: APPROVED, value: _seleteSE.SalesCode.toString());
    storage.write(key: PLANAPPROVED, value: _selectdDayPlan.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TsmApprove(),
      ),
    );
  }

  Widget leadIcon(String status) {
    bool isDone = false;
    status == 'APPROVED' ? isDone = true : isDone = false;
    return Container(
      height: 42,
      width: 43,
      decoration: BoxDecoration(
          color: isDone ? Colors.green : Colors.orange,
          shape: BoxShape.circle,
          border: isDone
              ? Border.all(color: Colors.green)
              : Border.all(color: Colors.orange)),
      child: Icon(
        Icons.assured_workload_rounded,
        color: isDone ? Colors.white : Colors.white,
      ),
    );
  }
}
