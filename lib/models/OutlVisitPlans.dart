class OutlVisitPlans {
  OutlVisitPlans({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory OutlVisitPlans.fromJson(Map<String, dynamic> json) => OutlVisitPlans(
        success: json["success"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    this.OutletID,
    this.OutletName,
    this.OutlSelected
  });

  String OutletID;
  String OutletName;
  int OutlSelected;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        OutletID: json["OutletID"],
        OutletName: json["OutletName"], 
        OutlSelected: json["Outl_Selected"],
      );
}
