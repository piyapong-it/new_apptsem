import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/models/productmaster.dart';
import 'package:tsem/models/productmasterbyvisit.dart';

import '../constants.dart';

class ProductApi {
  final Dio _dio = Dio();

  ProductApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<ProductMaster> fetchProductMaster({String own}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"own": own};

      final uri =
          Uri.https(endpoint, "/api/product/getProductMaster", queryParameters);
      Response response = await _dio.get(uri.toString(),
      options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      ProductMaster result = ProductMaster.fromJson(jsonResponse);

      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<ProductMasterByVisit> fetchProductByVisitId(
      {String own, String visitid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"own": own, "visitid": visitid};

      final uri = Uri.https(
          endpoint, "/api/product/getProductByVisitId", queryParameters);

      Response response = await _dio.get(uri.toString(),
      options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      ProductMasterByVisit result = ProductMasterByVisit.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }
}
