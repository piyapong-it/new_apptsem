class VisitPlans {
  VisitPlans({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitPlans.fromJson(Map<String, dynamic> json) => VisitPlans(
        success: json["success"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    this.planId,
    this.startDate,
    this.outletKey,
    this.outletName,
    this.status,
  });

  String planId;
  DateTime startDate;
  String outletKey;
  String outletName;
  String status;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        planId: json["PLAN_ID"],
        startDate: DateTime.parse(json["START_DATE"]),
        outletKey: json["OUTLET_KEY"],
        outletName: json["OUTLET_NAME"],
        status: json["STATUS"],
      );
}
