class OutletAll {
  OutletAll({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<OutletAllResult> result;

  factory OutletAll.fromJson(Map<String, dynamic> json) => OutletAll(
    success: json["success"],
    message: json["message"],
    result: List<OutletAllResult>.from(json["result"].map((x) => OutletAllResult.fromJson(x))),
  );

    Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class OutletAllResult {
  OutletAllResult({
    this.outletKey,
    this.outletId,
    this.outletName,
  });

  String outletKey;
  String outletId;
  String outletName;
 

  factory OutletAllResult.fromJson(Map<String, dynamic> json) => OutletAllResult(
    outletKey: json["CM#OUTL_KEY"].toString(),
    outletId: json["CM#OUTL_ID"].toString(),
    outletName: json["CM#OUTL_NAME"]
  );

    Map<String, dynamic> toJson() => {
    "CM#OUTL_KEY": outletKey,
    "CM#OUTL_ID": outletId,
    "CM#OUTL_NAME": outletName,
  };
}
