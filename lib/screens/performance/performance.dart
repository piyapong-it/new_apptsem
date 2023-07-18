import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tsem/components/msg_alert.dart';
import 'package:tsem/models/visitcount.dart';
import 'package:tsem/provider/visit_provider.dart';
import 'package:tsem/screens/sign_in/sign_in_screen.dart';

class PerformanceScreen extends StatefulWidget {
  static String routeName = "/performance";

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  List<charts.Series<Result, String>> _seriesData;
  List<Result> _nodes = [];
  List<Result> _nodesCompleted = [];
  List<Result> _nodesNotCompleted = [];
  List<Result> _nodesNotVisit = [];

  MessageAlert messageAlert = MessageAlert();

  _generateData() {
    VisitProvider().getVisitCount().then((value) {
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
        Navigator.of(context).pop();
        messageAlert.okAlert(
            context: context,
            message: "There isn't Chart data",
            title: "Please contact admin");
      }
      setState(() {
        _seriesData = <charts.Series<Result, String>>[];

        _nodes.addAll(value.result);

        _nodesCompleted = _nodes.where((note) {
          var noteTitle = note.visitStatus.toLowerCase();
          return noteTitle == 'completed';
        }).toList();

        _seriesData.add(
          charts.Series(
            data: _nodesCompleted,
            domainFn: (Result xx, _) => xx.visitType,
            measureFn: (Result xx, _) => xx.visitCount,
            id: 'Completed',
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            colorFn: (Result xx, _) =>
                charts.ColorUtil.fromDartColor(Color(0xff990099)),
            labelAccessorFn: (Result row, _) => '${row.visitCount}',
          ),
        );

        _nodesNotCompleted = _nodes.where((note) {
          var noteTitle = note.visitStatus.toLowerCase();
          return noteTitle.contains('not complete');
        }).toList();

        _seriesData.add(
          charts.Series(
            data: _nodesNotCompleted,
            domainFn: (Result xx, _) => xx.visitType,
            measureFn: (Result xx, _) => xx.visitCount,
            id: 'NotComplete',
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            colorFn: (Result xx, _) =>
                charts.ColorUtil.fromDartColor(Color(0xff109618)),
            labelAccessorFn: (Result row, _) => '${row.visitCount}',
          ),
        );

        _nodesNotVisit = _nodes.where((note) {
          var noteTitle = note.visitStatus.toLowerCase();
          return noteTitle.contains('not visit');
        }).toList();

        _seriesData.add(
          charts.Series(
            data: _nodesNotVisit,
            domainFn: (Result xx, _) => xx.visitType,
            measureFn: (Result xx, _) => xx.visitCount,
            id: 'NotVisit',
            fillPatternFn: (_, __) => charts.FillPatternType.solid,
            colorFn: (Result xx, _) =>
                charts.ColorUtil.fromDartColor(Color(0xff9962D0)),
            labelAccessorFn: (Result row, _) => '${row.visitCount}',
          ),
        );
      });
    }).catchError((err) {
      print(err);
      messageAlert.okAlert(
          context: context,
          message: "Connection error",
          title: "Please contact admin");
    });
  }

  @override
  void initState() {
    super.initState();

    _seriesData = <charts.Series<Result, String>>[];
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Performance',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(Icons.insert_chart_outlined)),
                // Tab(icon: Icon(Icons.pie_chart)),
                // Tab(icon: Icon(Icons.stacked_line_chart)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Visit Count by Type',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: true,
                          barGroupingType: charts.BarGroupingType.grouped,
                          behaviors: [new charts.SeriesLegend()],
                          animationDuration: Duration(seconds: 3),
                          defaultRenderer: new charts.BarRendererConfig(
                            fillPattern: charts.FillPatternType.solid,
                            customRendererId: "barid",
                            barRendererDecorator: charts.BarLabelDecorator(
                                labelPosition: charts.BarLabelPosition.auto,
                                labelAnchor: charts.BarLabelAnchor.middle),
                            cornerStrategy: const charts.ConstCornerStrategy(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Container(
              //     child: Center(
              //       child: Column(
              //         children: <Widget>[
              //           Text(
              //             'Time spent on daily tasks',
              //             style: TextStyle(
              //                 fontSize: 24.0, fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(
              //             height: 10.0,
              //           ),
              //           Expanded(
              //             child: charts.PieChart(
              //                 _seriesData,
              //                 animate: true,
              //                 animationDuration: Duration(seconds: 5),
              //                 behaviors: [
              //                   new charts.DatumLegend(
              //                     outsideJustification: charts.OutsideJustification.endDrawArea,
              //                     horizontalFirst: false,
              //                     desiredMaxRows: 2,
              //                     cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              //                     entryTextStyle: charts.TextStyleSpec(
              //                         color: charts.MaterialPalette.purple.shadeDefault,
              //                         fontFamily: 'Georgia',
              //                         fontSize: 11),
              //                   )
              //                 ],
              //                 defaultRenderer: new charts.ArcRendererConfig(
              //                     arcWidth: 100,
              //                     arcRendererDecorators: [
              //                       new charts.ArcLabelDecorator(
              //                           labelPosition: charts.ArcLabelPosition.inside)
              //                     ])),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Container(
              //     child: Center(
              //       child: Column(
              //         children: <Widget>[
              //           Text(
              //             'Sales for the first 5 years',
              //             style: TextStyle(
              //                 fontSize: 24.0, fontWeight: FontWeight.bold),
              //           ),
              //           Expanded(
              //             child: charts.LineChart(
              //                 _seriesData,
              //                 defaultRenderer: new charts.LineRendererConfig(
              //                     includeArea: true, stacked: true),
              //                 animate: true,
              //                 animationDuration: Duration(seconds: 5),
              //                 behaviors: [
              //                   new charts.ChartTitle('Years',
              //                       behaviorPosition: charts.BehaviorPosition.bottom,
              //                       titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
              //                   new charts.ChartTitle('Sales',
              //                       behaviorPosition: charts.BehaviorPosition.start,
              //                       titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
              //                   new charts.ChartTitle('Departments',
              //                     behaviorPosition: charts.BehaviorPosition.end,
              //                     titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
              //                   )
              //                 ]
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
