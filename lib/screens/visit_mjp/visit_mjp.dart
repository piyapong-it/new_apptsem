import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tsem/components/default_control.dart';

import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visitmjp.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';
import 'package:tsem/screens/visit_start/visit_start.dart';

class VisitMjpScreen extends StatefulWidget {
  static String routeName = "/visitmjp";

  @override
  _VisitMjpScreenState createState() => _VisitMjpScreenState();
}

class _VisitMjpScreenState extends State<VisitMjpScreen>
    with TickerProviderStateMixin {
  MessageAlert messageAlert = MessageAlert();
  List<Result> _nodes = [];
  List _selectedEvents;
  final _selectedDay = DateTime.now();

  Map<DateTime, List<dynamic>> _events;
  CalendarController _calendarController;
  AnimationController _animationController;

  Map<DateTime, List<dynamic>> _groupEvents(List<Result> events) {
    Map<DateTime, List<dynamic>> mapFetch = {};
    events.forEach((event) {
      DateTime date = DateTime(
          event.visitDate.year, event.visitDate.month, event.visitDate.day, 12);
      if (mapFetch[date] == null) mapFetch[date] = [];
      mapFetch[date].add(event);
    });
    return mapFetch;
  }

  void getMjpData() {
    VisitProvider().getMjp().then((value) {
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
        //Not exists MJP
      } else {
        // _nodes =  [];
        setState(() {
          _nodes.addAll(value.result);
          _events = _groupEvents(_nodes);
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

  void _onDaySelected(DateTime day, List<dynamic> events) {
    setState(() {
      _selectedEvents = events;
      print('_selectedEvents$_selectedEvents$_selectedDay');
    });
  }

  @override
  void initState() {
    _events = {};
    _selectedEvents = [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    getMjpData();
    print("init visit mjp");
    super.initState();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: DefaultControl.headerText(headText: "Journey Plan"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () {
              // _scrollController.animateTo(0,
              //     duration: Duration(seconds: 1), curve: Curves.easeInOut);
              setState(() {
                setState(() {
                  _nodes = [];
                  _events = {};
                  _selectedEvents = [];
                  getMjpData();
                  //_selectedDay = DateTime.now();
                });
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTableCalendarWithBuilders(),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, OutletScreen.routeName);
        },
        tooltip: 'Unplan',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      //locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.week,
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
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        todayColor: Colors.orange,
        selectedColor: Theme.of(context).primaryColor,
        todayStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.orange,
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
                color: Colors.amber[400],
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
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
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
    //_nodes[0].visitStatus

    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.4),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      event.visitStatus = "CANCEL";
                      VisitProvider().updateVisit(
                          visitId: event.visitId, visitStatus: "CANCEL");
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
                  child: ListTile(
                      leading: leadIcon(event.visitStatus),
                      title: Text(
                        "${event.outletName} ${event.outletid}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                      subtitle: Text(
                        "${event.address}"
                        "\n${event.outletType}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                      trailing: Text(
                        "${event.visitType}"
                        "\n${event.visitStatus}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.green,
                            fontSize: 15.0),
                      ),
                      onTap: () {
                        eventClick(event);
                      }),
                ),
              ),
      )
          .toList(),
    );
  }

  Widget leadIcon(String status) {
    bool isDone = false;
    status == 'DONE' ? isDone = true : isDone = false;

    return Container(
      height: 42,
      width: 43,
      decoration: BoxDecoration(
          color: isDone ? Colors.green : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green)),
      child: Icon(
        Icons.play_arrow,
        color: isDone ? Colors.white : Colors.green,
      ),
    );
  }

  void eventClick(dynamic event) {
    DateTime chkDate = DateTime.now().add(Duration(days: -10));
    DateTime visitDate = event.visitDate;

    if (chkDate.isAfter(visitDate)) {
      messageAlert.okAlert(
          context: context,
          message: "Visit error",
          title: "ไม่สามารถเยี่ยมร้านค้าย้อนหลังเกิน 10 วันได้");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitStart(
              outletId: event.outletid,
              //visitDate: DateTime.now(),
              visitDate: visitDate,
              outletName: event.outletName,
              outletAddress: event.address,
              outletImage: event.imagePath,
            ),
          )).then((value) {
        setState(() {
          //print("After visit start");
          // setState(() {
          //   _nodes = [];
          //   _events = {};
          //   _selectedEvents = [];
          //   getMjpData();
          //   //_selectedDay = DateTime.now();
          // });
        });
      });
    }
  }
}
