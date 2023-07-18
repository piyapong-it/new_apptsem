class DefectTrans {
  DefectTrans({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory DefectTrans.fromJson(Map<String, dynamic> json) => DefectTrans(
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
    this.defCategory,
    this.category,
    this.defStatus,
    this.statusname,
    this.defImage,
    this.defectImage,
    this.defPmid,
    this.pmName,
    this.visitDate,
    this.batchCode,
    this.defRemark,
    this.updateBy,
    this.updateDate,
  });

  int id;
  String outletId;
  String outletName;
  String outletType;
  String defCategory;
  String category;
  String defStatus;
  String statusname;
  String defImage;
  String defectImage;
  int defPmid;
  String pmName;
  DateTime visitDate;
  DateTime batchCode;
  String defRemark;
  String updateBy;
  DateTime updateDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["ID"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    outletType: json["OutletType"],
    defCategory: json["DEF_CATEGORY"],
    category: json["CATEGORY"],
    defStatus: json["DEF_STATUS"],
    statusname: json["STATUSNAME"],
    defImage: json["DEF_IMAGE"] == null ? null : json["DEF_IMAGE"],
    defectImage: json["DefectImage"] == null ? null : json["DefectImage"],
    defPmid: json["DEF_PMID"] == null ? null : json["DEF_PMID"],
    pmName: json["PM_NAME"] == null ? null : json["PM_NAME"],
    visitDate: json["VisitDate"] == null ? null : DateTime.parse(json["VisitDate"]),
    batchCode: json["BatchCode"] == null ? null : DateTime.parse(json["BatchCode"]),
    defRemark: json["DEF_REMARK"] == null ? null : json["DEF_REMARK"],
    updateBy: json["UPDATE_BY"] == null ? null : json["UPDATE_BY"],
    updateDate: json["UPDATE_DATE"] == null ? null : DateTime.parse(json["UPDATE_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "OutletID": outletId,
    "OutletName": outletName,
    "OutletType": outletType,
    "DEF_CATEGORY": defCategory,
    "CATEGORY": category,
    "DEF_STATUS": defStatus,
    "STATUSNAME": statusname,
    "DEF_IMAGE": defImage == null ? null : defImage,
    "DefectImage": defectImage == null ? null : defectImage,
    "DEF_PMID": defPmid == null ? null : defPmid,
    "PM_NAME": pmName == null ? null : pmName,
    "VisitDate": visitDate == null ? null : visitDate.toIso8601String(),
    "BatchCode": batchCode == null ? null : batchCode.toIso8601String(),
    "DEF_REMARK": defRemark == null ? null : defRemark,
    "UPDATE_BY": updateBy == null ? null : updateBy,
    "UPDATE_DATE": updateDate == null ? null : updateDate.toIso8601String(),
  };
}
