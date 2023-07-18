class Questions {
  Questions({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
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
    this.qid,
    this.qSeq,
    this.qCategory,
    this.qText,
    this.qRemark,
    this.aid,
    this.aSeq,
    this.aText,
    this.finishFlag,
    this.finishText,
    this.aNextQid,
  });

  int qid;
  int qSeq;
  String qCategory;
  String qText;
  String qRemark;
  int aid;
  int aSeq;
  String aText;
  String finishFlag;
  String finishText;
  int aNextQid;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    qid: json["QID"],
    qSeq: json["QSeq"],
    qCategory: json["QCategory"],
    qText: json["QText"],
    qRemark: json["QRemark"],
    aid: json["AID"] == null ? null : json["AID"],
    aSeq: json["ASeq"] == null ? null : json["ASeq"],
    aText: json["AText"] == null ? null : json["AText"],
    finishFlag: json["FinishFlag"] == null ? null :json["FinishFlag"],
    finishText: json["FinishText"],
    aNextQid: json["ANextQID"] == null ? null : json["ANextQID"],
  );

  Map<String, dynamic> toJson() => {
    "QID": qid,
    "QSeq": qSeq,
    "QCategory": qCategory,
    "QText": qText,
    "QRemark": qRemark,
    "AID": aid == null ? null : aid,
    "ASeq": aSeq == null ? null : aSeq,
    "AText": aText == null ? null : aText,
    "FinishFlag": finishFlag == null ? null : finishFlag,
    "FinishText": finishText,
    "ANextQID": aNextQid == null ? null : aNextQid,
  };
}


