import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tsem/constants.dart';
import 'package:tsem/models/complaintquestion.dart';
import 'package:tsem/models/complaintquiz.dart' as quiz;
import 'package:tsem/models/complainttrans.dart' as complainttrans;
import 'package:tsem/models/defecttrans.dart';
import 'package:tsem/models/dmlmessage.dart';
import 'package:tsem/models/salesfolder.dart';
import 'package:tsem/models/tasktrans.dart';
import 'package:tsem/models/udc.dart';
import 'package:tsem/models/uploadimage.dart';
import 'package:tsem/models/user.dart';

class TsemApi {
  final Dio _dio = Dio();

  TsemApi() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<User> fetchUser({userId, password}) async {
    try {
      final uri = Uri.https(endpoint, "/api/users/login");
      Response response = await _dio
          .post(uri.toString(), data: {"userId": userId, "password": password});
      var jsonResponse = json.decode(response.data);
      User userRec = User.fromJson(jsonResponse);
      return userRec;
    } catch (e) {
      print('E ${e}');
    }
  }

  Future<Udc> fetchUdc({String id, String md, String key}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"id": id, "md": md, "key": key};

      final uri = Uri.https(endpoint, "/api/misc/getUDC", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      Udc result = Udc.fromJson(jsonResponse);
      print("_______________________");
      print(result);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<SalesFolder> fetchSalesFolder() async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/getSalesFolder");

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);
      SalesFolder result = SalesFolder.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<UploadImage> uploadImageDefect(
      {String outletid, File imageFile}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      String fileName = imageFile.path.split('/').last;

      final uri = Uri.https(endpoint, "/upload");

      final mimeTypeData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

      FormData formData = FormData.fromMap({
        "defect": await MultipartFile.fromFile(imageFile.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "outletId": outletid
      });

      Response response = await _dio.post(uri.toString(),
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      UploadImage result = UploadImage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DefectTrans> fetchDefectTrans(
      {String outletid, String defectid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"outletid": outletid, "defectid": defectid};

      final uri =
          Uri.https(endpoint, "/api/misc/getDefectTrans", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);

      DefectTrans result = DefectTrans.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage>createUser(Object data) async {
    try {
      final uri = Uri.https(endpoint, "/api/users/createUserByTSEM");
      Response response = await _dio.post(uri.toString(), data: data);

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DmLmessage>updatePwd(Object data) async {
    try {
      final uri = Uri.https(endpoint, "/api/users/updatePws");
      Response response = await _dio.post(uri.toString(), data: data);

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DmLmessage> updateDefect(
      {String defectid,
      String outletid,
      String defectcategory,
      String defectstatus,
      int pmid,
      String batchcode,
      String defectimage,
      String defectremark}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdeCode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/updateDefect");
      Response response = await _dio.post(uri.toString(),
          data: {
            "defectid": defectid,
            "outletid": outletid,
            "defectcategory": defectcategory,
            "defectstatus": defectstatus,
            "pmid": pmid,
            "batchcode": batchcode,
            "defectimage": defectimage,
            "defectremark": defectremark,
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

  Future<UploadImage> uploadImageTask({String outletid, File imageFile}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      String fileName = imageFile.path.split('/').last;

      final uri = Uri.https(endpoint, "/upload/uploadTaskImage");

      final mimeTypeData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

      FormData formData = FormData.fromMap({
        "task": await MultipartFile.fromFile(imageFile.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "outletId": outletid
      });

      Response response = await _dio.post(uri.toString(),
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      UploadImage result = UploadImage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<TaskTrans> fetchMyTaskTrans({String taskstatus}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdecode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"salesid": _jdecode, "taskstatus": taskstatus};

      final uri =
          Uri.https(endpoint, "/api/misc/getMyTaskTrans", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);

      TaskTrans result = TaskTrans.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<TaskTrans> fetchTaskTrans({String outletid, String taskid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"outletid": outletid, "taskid": taskid};

      final uri =
          Uri.https(endpoint, "/api/misc/getTaskTrans", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);

      TaskTrans result = TaskTrans.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> updateTask(
      {String taskid,
      String outletid,
      String taskcategory,
      String taskstatus,
      String taskimage,
      DateTime duedate,
      DateTime completedate,
      String taskremark}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdeCode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/updateTask");
      Response response = await _dio.post(uri.toString(),
          data: {
            "taskid": taskid,
            "outletid": outletid,
            "taskcategory": taskcategory,
            "taskstatus": taskstatus,
            "taskimage": taskimage,
            "duedate": DateFormat('yyyy-MM-dd').format(duedate),
            "completedate": DateFormat('yyyy-MM-dd').format(completedate),
            "taskremark": taskremark,
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

  Future<UploadImage> uploadImageOutlet(
      {String outletid, File imageFile}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      String fileName = imageFile.path.split('/').last;

      final uri = Uri.https(endpoint, "/upload/uploadOutletImage");

      final mimeTypeData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

      FormData formData = FormData.fromMap({
        "profile": await MultipartFile.fromFile(imageFile.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "outletId": outletid
      });

      Response response = await _dio.post(uri.toString(),
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      UploadImage result = UploadImage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DmLmessage> updateOutletImage(
      {String outletid, String imagepath}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/updateOutletImage");
      Response response = await _dio.post(uri.toString(),
          data: {"outletid": outletid, "imagepath": imagepath},
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      DmLmessage result = DmLmessage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<complainttrans.ComplaintTrans> fetchComplaintTrans(
      {String outletid, String complaintid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {
        "outletid": outletid,
        "complaintid": complaintid
      };

      final uri =
          Uri.https(endpoint, "/api/misc/getComplaintTrans", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);

      complainttrans.ComplaintTrans result =
          complainttrans.ComplaintTrans.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<Questions> fetchComplaintQuestion({String category}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"category": category};

      final uri =
          Uri.https(endpoint, "/api/misc/getCPQuestion", queryParameters);

      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      var jsonResponse = json.decode(response.data);

      Questions result = Questions.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<quiz.ComplaintQuiz> fetchComplaintQuiz({String complaintid}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      final queryParameters = {"category": complaintid};

      final uri =
          Uri.https(endpoint, "/api/misc/getComplaintQuiz", queryParameters);
      Response response = await _dio.get(uri.toString(),
          options: Options(headers: {"Authorization": "Bearer $_token"}));
      print(response);
      var jsonResponse = json.decode(response.data);

      quiz.ComplaintQuiz result = quiz.ComplaintQuiz.fromJson(jsonResponse);
      return result;
    } catch (e) {
      return (e);
    }
  }

  Future<DmLmessage> updateCompliantTrans(
      {complainttrans.Result complaintTrans}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdeCode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/updateComplaintTrans");

      Response response = await _dio.post(uri.toString(),
          data: {
            "complaintid": complaintTrans.rid,
            "outletid": complaintTrans.outletId,
            "complaintdate":
                DateFormat('yyyy-MM-dd').format(complaintTrans.rDate),
            "complaintstatus": complaintTrans.rstatus,
            "pmid": complaintTrans.rpmid,
            "image1": complaintTrans.cpImage1,
            "image2": complaintTrans.cpImage2,
            "image3": complaintTrans.cpImage3,
            "image4": complaintTrans.cpImage4,
            "quantity": complaintTrans.rQuantity,
            "remark": complaintTrans.rRemark,
            "finishtext": complaintTrans.finishText,
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

  Future<UploadImage> uploadImageComplaint(
      {String outletid, File imageFile}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _token = await storage.read(key: USERTOKEN);

      String fileName = imageFile.path.split('/').last;

      final uri = Uri.https(endpoint, "/upload/uploadComplaintImage");

      final mimeTypeData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

      FormData formData = FormData.fromMap({
        "complaint": await MultipartFile.fromFile(imageFile.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "outletId": outletid
      });

      Response response = await _dio.post(uri.toString(),
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $_token"}));

      var jsonResponse = json.decode(response.data);

      UploadImage result = UploadImage.fromJson(jsonResponse);

      return result;
    } catch (e) {
      print('e: ${e}');
      return (e);
    }
  }

  Future<DmLmessage> updateCompliantQuiz({quiz.Result complaintQuiz}) async {
    try {
      final storage = new FlutterSecureStorage();
      String _jdeCode = await storage.read(key: JDECODE);
      String _token = await storage.read(key: USERTOKEN);

      final uri = Uri.https(endpoint, "/api/misc/updateComplaintQuiz");

      Response response = await _dio.post(uri.toString(),
          data: {
            "quizid": complaintQuiz.zid,
            "complaintid": complaintQuiz.rid,
            "questionid": complaintQuiz.qid,
            "questionseq": complaintQuiz.qSeq,
            "questiontext": complaintQuiz.qText,
            "questioncategory": complaintQuiz.qCategory,
            "answerid": complaintQuiz.aid,
            "answertext": complaintQuiz.aText,
            "finishtext": complaintQuiz.finishText,
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
