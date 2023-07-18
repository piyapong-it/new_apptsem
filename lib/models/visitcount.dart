class VisitCount {
  VisitCount({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitCount.fromJson(Map<String, dynamic> json) => VisitCount(
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
    this.visitType,
    this.visitStatus,
    this.visitCount,
  });

  String visitType;
  String visitStatus;
  int visitCount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    visitType: json["VISIT_TYPE"],
    visitStatus: json["VISIT_STATUS"],
    visitCount: json["VisitCount"],
  );

  Map<String, dynamic> toJson() => {
    "VISIT_TYPE": visitType,
    "VISIT_STATUS": visitStatus,
    "VisitCount": visitCount,
  };
}
