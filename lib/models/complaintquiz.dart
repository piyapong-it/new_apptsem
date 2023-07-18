class ComplaintQuiz {
  ComplaintQuiz({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ComplaintQuiz.fromJson(Map<String, dynamic> json) => ComplaintQuiz(
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
    this.zid,
    this.rid,
    this.qid,
    this.qSeq,
    this.qText,
    this.qCategory,
    this.aid,
    this.aText,
    this.finishText,
    this.updateBy,
    this.updateDate,
  });

  int zid;
  int rid;
  int qid;
  int qSeq;
  String qText;
  String qCategory;
  int aid;
  String aText;
  String finishText;
  String updateBy;
  DateTime updateDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    zid: json["ZID"],
    rid: json["RID"],
    qid: json["QID"],
    qSeq: json["QSeq"],
    qText: json["QText"],
    qCategory: json["QCategory"],
    aid: json["AID"],
    aText: json["AText"],
    finishText: json["FinishText"] == null ? null : json["FinishText"],
    updateBy: json["UpdateBy"],
    updateDate: DateTime.parse(json["UpdateDate"]),
  );

  Map<String, dynamic> toJson() => {
    "ZID": zid,
    "RID": rid,
    "QID": qid,
    "QSeq": qSeq,
    "QText": qText,
    "QCategory": qCategory,
    "AID": aid,
    "AText": aText,
    "FinishText": finishText == null ? null : finishText,
    "UpdateBy": updateBy,
    "UpdateDate": updateDate.toIso8601String(),
  };
}
