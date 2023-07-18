class Visit {
  Visit({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
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
    this.visitId,
    this.outletId,
    this.visitDate,
    this.visitType,
    this.visitLat,
    this.visitLng,
    this.status,
    this.startDate,
    this.endDate,
    this.updateBy,
    this.smName,
    this.updateDate,
  });

  String visitId;
  String outletId;
  DateTime visitDate;
  String visitType;
  String visitLat;
  String visitLng;
  String status;
  DateTime startDate;
  DateTime endDate;
  String updateBy;
  String smName;
  DateTime updateDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    visitId: json["VISIT_ID"],
    outletId: json["OutletID"],
    visitDate: DateTime.parse(json["VISIT_DATE"]),
    visitType: json["VISIT_TYPE"],
    visitLat: json["VISIT_LAT"] == null ? null : json["VISIT_LAT"],
    visitLng: json["VISIT_LNG"] == null ? null : json["VISIT_LNG"],
    status: json["STATUS"] == null ? null : json["STATUS"],
    startDate: json["START_DATE"] == null ? null : DateTime.parse(json["START_DATE"]),
    endDate: json["END_DATE"] == null ? null : DateTime.parse(json["END_DATE"]),
    updateBy: json["UPDATE_BY"] == null ? null : json["UPDATE_BY"],
    smName: json["SM_NAME"] == null ? null : json["SM_NAME"],
    updateDate: json["UPDATE_DATE"] == null ? null : DateTime.parse(json["UPDATE_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "VISIT_ID": visitId,
    "OutletID": outletId,
    "VISIT_DATE": visitDate.toIso8601String(),
    "VISIT_TYPE": visitType,
    "VISIT_LAT": visitLat == null ? null : visitLat,
    "VISIT_LNG": visitLng == null ? null : visitLng,
    "STATUS": status == null ? null : status,
    "START_DATE": startDate == null ? null : startDate.toIso8601String(),
    "END_DATE": endDate == null ? null : "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "UPDATE_BY": updateBy == null ? null : updateBy,
    "SM_NAME": smName == null ? null : smName,
    "UPDATE_DATE": updateDate == null ? null : updateDate.toIso8601String(),
  };
}
