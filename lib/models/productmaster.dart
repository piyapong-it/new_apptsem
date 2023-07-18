class ProductMaster {
  ProductMaster({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory ProductMaster.fromJson(Map<String, dynamic> json) => ProductMaster(
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
    this.pmId,
    this.pmName,
    this.pmType,
    this.pmSize,
    this.bmId,
    this.bmName,
    this.bmOwn,
  });

  int pmId;
  String pmName;
  String pmType;
  String pmSize;
  int bmId;
  String bmName;
  String bmOwn;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pmId: json["PM_ID"],
    pmName: json["PM_NAME"],
    pmType: json["PM_TYPE"],
    pmSize: json["PM_SIZE"],
    bmId: json["BM_ID"],
    bmName: json["BM_NAME"],
    bmOwn: json["BM_OWN"],
  );

  Map<String, dynamic> toJson() => {
    "PM_ID": pmId,
    "PM_NAME": pmName,
    "PM_TYPE": pmType,
    "PM_SIZE": pmSize,
    "BM_ID": bmId,
    "BM_NAME": bmName,
    "BM_OWN": bmOwn,
  };
}
