import 'package:flutter/widgets.dart';
import 'package:tsem/screens/address/detail.dart';
import 'package:tsem/screens/asset/asset_master.dart';
import 'package:tsem/screens/complaint/complaint.dart';
import 'package:tsem/screens/defect/defect.dart';
import 'package:tsem/screens/forgot_password/forgot_password.dart';
import 'package:tsem/screens/home/home_screen.dart';
import 'package:tsem/screens/new_outlet/components/forms_outletRequset.dart';
import 'package:tsem/screens/new_outlet/history.dart';
import 'package:tsem/screens/outlet/outlet_screen.dart';
import 'package:tsem/screens/outlet_census/outlet_census_map_screen.dart';
import 'package:tsem/screens/outlet_detail/outlet_detail.dart';
import 'package:tsem/screens/outlet_map/outlet_map_screen.dart';
import 'package:tsem/screens/outlet_nearby/outlet_nearby_screen.dart';
import 'package:tsem/screens/outlet_nearby_map/outlet_nearby_map_screen.dart';
import 'package:tsem/screens/performance/performance.dart';
import 'package:tsem/screens/sales_folder/sales_folder.dart';
import 'package:tsem/screens/sales_folder/sales_folder_view.dart';
import 'package:tsem/screens/sign_up/signup_form.dart';
import 'package:tsem/screens/task/mytask.dart';
import 'package:tsem/screens/task/task.dart';
import 'package:tsem/screens/tsm_approve/tsm_approve.dart';
import 'package:tsem/screens/visit_agenda/visit_agenda.dart';
import 'package:tsem/screens/visit_callcard/visit_callcard.dart';
import 'package:tsem/screens/visit_history/visit_history.dart';
import 'package:tsem/screens/visit_mjp/visit_mjp.dart';
import 'package:tsem/screens/visit_plan/visit_plan.dart';
import 'package:tsem/screens/visit_start/visit_start.dart';
import 'screens/sign_in/sign_in_screen.dart';

// We use name route All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  OutletScreen.routeName:(context) => OutletScreen(),
  OutletDetail.routeName:(context) => OutletDetail(),
  OutletMap.routeName:(context) => OutletMap(),
  OutletNearbyScreen.routeName:(context) => OutletNearbyScreen(),
  OutletNearbyMap.routeName:(context) => OutletNearbyMap(),
  OutletCensusMap.routeName:(context) => OutletCensusMap(),
  VisitStart.routeName:(context) => VisitStart(),
  VisitAgendaScreen.routeName:(context) => VisitAgendaScreen(),
  VisitMjpScreen.routeName:(context) => VisitMjpScreen(),
  VisitCallCardScreen.routeName:(context) => VisitCallCardScreen(),
  AssetMaster.routeName:(context) => AssetMaster(),
  SalesFolderScreen.routeName:(context) => SalesFolderScreen(),
  PerformanceScreen.routeName:(context) => PerformanceScreen(),
  VisitHistory.routeName:(context) => VisitHistory(),
  Defect.routeName:(context) => Defect(),
  TaskScreen.routeName:(context) => TaskScreen(),
  MyTaskScreen.routeName:(context) => MyTaskScreen(),
  SalesFolderView.routeName:(context) => SalesFolderView(),
  ComplaintScreen.routeName:(context) => ComplaintScreen(),
  Detail.routeName:(context) => Detail(),
  VisitPlan.routeName:(context) => VisitPlan(),
  TsmApprove.routeName:(context) => TsmApprove(),
  HistoryNewOutlet.routeName:(context) => HistoryNewOutlet(),
  FormsOutletRequest.routeName:(context) => FormsOutletRequest(),
  SignUpFrom.routeName:(context) => SignUpFrom(),
   ForgetPassword.routeName:(context) => ForgetPassword(),
};
