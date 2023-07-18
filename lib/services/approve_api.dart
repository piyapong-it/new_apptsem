import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/models/extendbyasm.dart';

import '../constants.dart';

class ApproveApi {
  final Dio _dio = Dio();

  ApproveApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<DmLmessage> UpdateStatusAndSendMail(
      {String VisitDate, String EmpJDE, String Status}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/approve/sendMailApprove/");
      Response response = await _dio.post(uri.toString(),
          data: {
            "VisitDate": VisitDate,
            "EmpJDE": EmpJDE,
            "Status": Status,
            "EmpLogin": _jdecode
          },
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);
      DmLmessage result = DmLmessage.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<ExtendByAsm> fetchExtendByAsm({String AsmCode}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/approve/getExtendByAsm/$AsmCode");
      print(uri.toString());
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      ExtendByAsm listSe = ExtendByAsm.fromJson(jsonResponse);
      return listSe;
    } catch (e) {
      print("catch");
      return (e);
    }
  }
}
