class ComplaintTrans {
  ComplaintTrans({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ComplaintTrans.fromJson(Map<String, dynamic> json) => ComplaintTrans(
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
    this.rid,
    this.outletId,
    this.outletName,
    this.outletType,
    this.rstatus,
    this.statusname,
    this.rDate,
    this.rpmid,
    this.pmName,
    this.cpImage1,
    this.cpImage2,
    this.cpImage3,
    this.cpImage4,
    this.rQuantity,
    this.rRemark,
    this.finishText,
    this.updateby,
    this.updatedate,
  });

  int rid;
  String outletId;
  String outletName;
  String outletType;
  String rstatus;
  String statusname;
  DateTime rDate;
  int rpmid;
  String pmName;
  String cpImage1;
  String cpImage2;
  String cpImage3;
  String cpImage4;
  int rQuantity;
  String rRemark;
  String finishText;
  String updateby;
  DateTime updatedate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    rid: json["RID"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    outletType: json["OutletType"],
    rstatus: json["RSTATUS"],
    statusname: json["STATUSNAME"],
    rDate: DateTime.parse(json["RDate"]),
    rpmid: json["RPMID"],
    pmName: json["PM_NAME"],
    cpImage1: json["CPImage1"],
    cpImage2: json["CPImage2"],
    cpImage3: json["CPImage3"],
    cpImage4: json["CPImage4"],
    rQuantity: json["RQuantity"],
    rRemark: json["RRemark"],
    finishText: json["FinishText"],
    updateby: json["UPDATEBY"],
    updatedate: DateTime.parse(json["UPDATEDATE"]),
  );

  Map<String, dynamic> toJson() => {
    "RID": rid,
    "OutletID": outletId,
    "OutletName": outletName,
    "OutletType": outletType,
    "RSTATUS": rstatus,
    "STATUSNAME": statusname,
    "RDate": rDate.toIso8601String(),
    "RPMID": rpmid,
    "PM_NAME": pmName,
    "CPImage1": cpImage1,
    "CPImage2": cpImage2,
    "CPImage3": cpImage3,
    "CPImage4": cpImage4,
    "RQuantity" : rQuantity,
    "RRemark": rRemark,
    "FinishText": finishText,
    "UPDATEBY": updateby,
    "UPDATEDATE": updatedate.toIso8601String(),
  };
}
