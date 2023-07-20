import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/models/outletdetail.dart';
import 'package:tsem/models/outletnearby.dart';
import 'package:tsem/models/outlets.dart';
import 'package:tsem/models/outlettype.dart';
import 'package:tsem/models/outletall.dart';
import 'package:tsem/models/outletupdate.dart';
import '../constants.dart';

class OutletApi {
  final Dio _dio = Dio();

  OutletApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Outlets> fetchMyOutlet() async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri =
          Uri.https(endpoint, "/api/outlets/getOutletsBySalesID/" + _jdecode);
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      Outlets outletResult = Outlets.fromJson(jsonResponse);

      return outletResult;
    } catch (e) {
      print('error ${e}');
      return (e);
    }
  }

  Future<Outlets> fetchMapOutlet() async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri =
          Uri.https(endpoint, "/api/outlets/getOutletsMapBySalesID/" + _jdecode);
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      Outlets outletResult = Outlets.fromJson(jsonResponse);

      return outletResult;
    } catch (e) {
      return (e);
    }
  }

  Future<OutletsNearby> fetchOutletNearby(
      {double lat, double lng, double km}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/outlets/getOutletsNearby");
      Response response = await _dio.post(uri.toString(),
          data: {"lat": lat, "lng": lng, "km": km},
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      OutletsNearby outletResult = OutletsNearby.fromJson(jsonResponse);
      return outletResult;
    } catch (e) {
      return (e);
    }
  }

  Future<OutletDetail> fetchOutletDetail({String outletid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri =
          Uri.https(endpoint, "/api/outlets/getOutletByOutletID/" + outletid);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      print('response$response');
      OutletDetail result = OutletDetail.fromJson(jsonResponse);
      print('result$result');
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<TypeStatus> fetchOutletTypeStatus(
      {String Sys_Id, String Sys_Md, String Sys_Enbled}) async {
        print('fetchOutletTypeStatus');
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/outlets/getOutletTypeStatus");
      Response response = await _dio.post(uri.toString(),
          data: {"Sys_Id": Sys_Id, "Sys_Md": Sys_Md, "Sys_Enbled": Sys_Enbled},
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      print(jsonResponse);
      TypeStatus outletResult = TypeStatus.fromJson(jsonResponse);
      return outletResult;
    } catch (e) {
      return (e);
    }
  }

  Future<OutletAll> fetchOutletAll() async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/outlets/getOutletAll");
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      print('TEST$jsonResponse');
      OutletAll outletResult = OutletAll.fromJson(jsonResponse);

      return outletResult;
    } catch (e) {
      return (e);
    }
  }

  Future<UpdateOutl> UpdateOutlet({data}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);
      final uri = Uri.https(endpoint, "/api/outlets/updateOutletDetail");
      Response response = await _dio.post(uri.toString(),
          data: data,
          options: Options(
              headers: {"Authorization": "Bearer $_token"},
              contentType: 'application/json'));
      var jsonResponse = json.decode(response.data);
      UpdateOutl result = UpdateOutl.fromJson(jsonResponse);
      return result;
    } catch (e) {
      print('E ${e}');
    }
  }
}
