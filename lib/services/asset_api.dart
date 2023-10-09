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

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
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
      String _jdeCode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/asset/updateAsset");

      Response response = await _dio.post(uri.toString(),
          data: {
            "stickerid": stickerid,
            "outletid": outletid,
            "assetcategory": assetcategory,
            "assetstatus": assetstatus,
            "assetsno": assetsno,
            "assetjdeno": assetjdeno,
            "assetremark": assetremark,
            "assetquantity": assetquantity,
            "updateby": _jdeCode
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }
}
