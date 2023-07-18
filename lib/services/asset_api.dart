import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/models/assetmaster.dart';
import 'package:tsem/models/dmlmessage.dart';

import '../constants.dart';

class AssetApi {
  final Dio _dio = Dio();

  AssetApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<AssetMaster> fetchAssetMaster({String outletid, String qrid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"outletid": outletid, "qrid": qrid};

      final uri =
          Uri.https(endpoint, "/api/asset/getAssetMaster", queryParameters);
      _dio.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
        var customHeaders = {
          'content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token'
        };
        options.headers.addAll(customHeaders);
        return options;
      }));

      Response response = await _dio.get(uri.toString());
      var jsonResponse = json.decode(response.data);

      AssetMaster result = AssetMaster.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> updateAsset(
      {String stickerid,
      String outletid,
      String assetcategory,
      String assetstatus,
      String assetsno,
      String assetjdeno,
      String assetremark,
      int assetquantity}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _username = await storage.read(key: USERNAME);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/asset/updateAsset");

      /*_dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) async{
        
      }));*/

      _dio.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
        var customHeaders = {
          'content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token'
        };
        options.headers.addAll(customHeaders);
        return options;
      }));

      Response response = await _dio.post(uri.toString(), data: {
        "stickerid": stickerid,
        "outletid": outletid,
        "assetcategory": assetcategory,
        "assetstatus": assetstatus,
        "assetsno": assetsno,
        "assetjdeno": assetjdeno,
        "assetremark": assetremark,
        "assetquantity": assetquantity,
        "updateby": _username
      });

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }
}
