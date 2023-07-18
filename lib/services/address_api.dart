import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tsem/models/province.dart';
import 'package:tsem/models/district.dart';
import 'package:tsem/models/subdistrict.dart';

import '../constants.dart';

class AddressApi {
  final Dio _dio = Dio();

  AddressApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Province> fetchProvince() async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/address/province");
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      Province result = Province.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<District> fetchDistrict({String province}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/address/" + province + "/district");

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      District result = District.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<SubDistrict> fetchSubDistrict({String district}) async {
    // print(district);
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri =
          Uri.https(endpoint, "/api/address/" + district + "/subdistrict");

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      // print(jsonResponse);
      SubDistrict result = SubDistrict.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }
}
