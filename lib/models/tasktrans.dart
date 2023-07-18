class TaskTrans {
  TaskTrans({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory TaskTrans.fromJson(Map<String, dynamic> json) => TaskTrans(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.outletId,
    this.outletName,
    this.outletType,
    this.taskCategory,
    this.category,
    this.taskStatus,
    this.statusname,
    this.taskImage,
    this.resultTaskImage,
    this.dueDate,
    this.completeDate,
    this.taskRemark,
    this.updateBy,
    this.updateDate,
  });

  int id;
  String outletId;
  String outletName;
  String outletType;
  String taskCategory;
  String category;
  String taskStatus;
  String statusname;
  String taskImage;
  String resultTaskImage;
  DateTime dueDate;
  DateTime completeDate;
  String taskRemark;
  String updateBy;
  DateTime updateDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["ID"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    outletType: json["OutletType"],
    taskCategory: json["TASK_CATEGORY"],
    category: json["CATEGORY"],
    taskStatus: json["TASK_STATUS"],
    statusname: json["STATUSNAME"],
    taskImage: json["TASK_IMAGE"] == null ? null : json["TASK_IMAGE"],
    resultTaskImage: json["TaskImage"] == null ? null : json["TaskImage"],
    dueDate: json["Due_Date"] == null ? null : DateTime.parse(json["Due_Date"]),
    completeDate: json["Complete_Date"] == null ? null : DateTime.parse(json["Complete_Date"]),
    taskRemark: json["TASK_REMARK"] == null ? null : json["TASK_REMARK"],
    updateBy: json["UPDATE_BY"] == null ? null : json["UPDATE_BY"],
    updateDate: DateTime.parse(json["UPDATE_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "OutletID": outletId,
    "OutletName": outletName,
    "OutletType": outletType,
    "TASK_CATEGORY": taskCategory,
    "CATEGORY": category,
    "TASK_STATUS": taskStatus,
    "STATUSNAME": statusname,
    "TASK_IMAGE": taskImage == null ? null : taskImage,
    "TaskImage": resultTaskImage == null ? null : resultTaskImage,
    "Due_Date": dueDate == null ? null : dueDate.toIso8601String(),
    "Complete_Date": completeDate == null ? null : completeDate.toIso8601String(),
    "TASK_REMARK": taskRemark == null ? null : taskRemark,
    "UPDATE_BY": updateBy == null ? null : updateBy,
    "UPDATE_DATE": updateDate.toIso8601String(),
  };
}
