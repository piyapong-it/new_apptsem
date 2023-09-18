import 'package:tsem/models/outletdetail.dart';
import 'package:tsem/models/outletnearby.dart';
import 'package:tsem/models/outletrequest.dart';
import 'package:tsem/models/outlets.dart';
import 'package:tsem/models/outlettype.dart';
import 'package:tsem/models/outletall.dart';
import 'package:tsem/models/outletupdate.dart';
import 'package:tsem/services/outlet_api.dart';

class OutletProvider {
  OutletApi api = OutletApi();

  Future<Outlets> getMyOutlet() async {
    return api.fetchMyOutlet();
  }

  Future<Outlets> getMapOutlet() async {
    return api.fetchMapOutlet();
  }

  Future<OutletsNearby> getOutletNearby(
      {double lat, double lng, double km}) async {
    return api.fetchOutletNearby(lat: lat, lng: lng, km: km);
  }

  Future<OutletDetail> getOutletByOutletId({String outletid}) async {
    return api.fetchOutletDetail(outletid: outletid);
  }

  Future<TypeStatus> getOutletTypeStatus(
      {String Sys_Id, String Sys_Md, String Sys_Enbled}) async {
    return api.fetchOutletTypeStatus(
        Sys_Id: Sys_Id, Sys_Md: Sys_Md, Sys_Enbled: Sys_Enbled);
  }

  Future<OutletAll> getOutletAll() async {
    return api.fetchOutletAll();
  }

  Future<UpdateOutl> UpdateOutlet({Object data}) async {
    return api.UpdateOutlet(data: data);
  }

  Future<OutletRequest> getOutletRequest() async {
    return api.fetchOutletRequest();
  }
}
