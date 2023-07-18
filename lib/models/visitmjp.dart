class VisitMjp {
  VisitMjp({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory VisitMjp.fromJson(Map<String, dynamic> json) => VisitMjp(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.planId,
    this.appointmentId,
    this.visitType,
    this.visitDate,
    this.outletid,
    this.outletName,
    this.address,
    this.outletType,
    this.imagePath,
    this.visitId,
    this.visitStatus,
  });

  String planId;
  String appointmentId;
  String visitType;
  DateTime visitDate;
  String outletid;
  String outletName;
  String address;
  String outletType;
  String imagePath;
  String visitId;
  String visitStatus;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    planId: json["PLAN_ID"],
    appointmentId: json["APPOINTMENT_ID"],
    visitType: json["VISIT_TYPE"],
    visitDate: DateTime.parse(json["VISIT_DATE"]),
    outletid: json["OUTLETID"],
    outletName: json["OUTLET_NAME"],
    address: json["ADDRESS"],
    outletType: json["OutletType"],
    imagePath: json["ImagePath"],
    visitId: json["VISIT_ID"],
    visitStatus: json["VISIT_STATUS"],
  );
}
