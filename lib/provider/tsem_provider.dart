import 'dart:io';

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
import 'package:tsem/services/tsem_api.dart';

class TsemProvider {
  TsemApi api = TsemApi();

  Future<User> getUser({String userId, String password}) async {
    return api.fetchUser(userId: userId, password: password);
  }

  Future<DmLmessage> signUp({Object data}) async {
    return api.createUser(data);
  }

   Future<DmLmessage> updatePassword({Object data}) async {
    return api.updatePwd(data);
  }

  Future<Udc> getUdc({String id, String md, String key}) async {
    return api.fetchUdc(id: id, md: md, key: key);
  }

  Future<SalesFolder> getSalesFolder() async {
    return api.fetchSalesFolder();
  }

  Future<UploadImage> uploadImageDefect(
      {String outletid, File imageFile}) async {
    return api.uploadImageDefect(outletid: outletid, imageFile: imageFile);
  }

  Future<DefectTrans> getDefectTrans({String outletid, String defectid}) async {
    return api.fetchDefectTrans(outletid: outletid, defectid: defectid);
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
    return api.updateDefect(
        defectid: defectid,
        outletid: outletid,
        defectcategory: defectcategory,
        defectstatus: defectstatus,
        defectimage: defectimage,
        batchcode: batchcode,
        defectremark: defectremark,
        pmid: pmid);
  }

  Future<UploadImage> uploadImageTask({String outletid, File imageFile}) async {
    return api.uploadImageTask(outletid: outletid, imageFile: imageFile);
  }

  Future<TaskTrans> getTaskTrans({String outletid, String taskid}) async {
    return api.fetchTaskTrans(outletid: outletid, taskid: taskid);
  }

  Future<TaskTrans> getMyTaskTrans({String taskstatus}) async {
    return api.fetchMyTaskTrans(taskstatus: taskstatus);
  }

  Future<DmLmessage> updateTask(
      {String taskid,
      String outletid,
      String taskcategory,
      String taskstatus,
      DateTime duedate,
      DateTime completedate,
      String taskimage,
      String taskremark}) async {
    return api.updateTask(
        taskid: taskid,
        outletid: outletid,
        taskcategory: taskcategory,
        duedate: duedate,
        completedate: completedate,
        taskstatus: taskstatus,
        taskimage: taskimage,
        taskremark: taskremark);
  }

  Future<UploadImage> uploadImageOutlet(
      {String outletid, File imageFile}) async {
    return api.uploadImageOutlet(outletid: outletid, imageFile: imageFile);
  }

  Future<DmLmessage> updateOutletImage(
      {String outletid, String imagepath}) async {
    return api.updateOutletImage(outletid: outletid, imagepath: imagepath);
  }

  Future<complainttrans.ComplaintTrans> getComplaintTrans(
      {String outletid, String complaintid}) async {
    return api.fetchComplaintTrans(
        outletid: outletid, complaintid: complaintid);
  }

  Future<Questions> getComplaintQuestion({String category}) async {
    return api.fetchComplaintQuestion(category: category);
  }

  Future<quiz.ComplaintQuiz> getComplaintQuiz({String complaintid}) async {
    return api.fetchComplaintQuiz(complaintid: complaintid);
  }

  Future<DmLmessage> updateComplaintTrans(
      {complainttrans.Result complaintTrans}) async {
    return api.updateCompliantTrans(complaintTrans: complaintTrans);
  }

  Future<UploadImage> uploadImageComplaint(
      {String outletid, File imageFile}) async {
    return api.uploadImageComplaint(outletid: outletid, imageFile: imageFile);
  }

  Future<DmLmessage> updateComplaintQuiz({quiz.Result complaintQuiz}) async {
    return api.updateCompliantQuiz(complaintQuiz: complaintQuiz);
  }
}
