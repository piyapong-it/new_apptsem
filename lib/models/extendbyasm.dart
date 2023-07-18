class ExtendByAsm {
  ExtendByAsm({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<ResultAsm> result;

  factory ExtendByAsm.fromJson(Map<String, dynamic> json) => ExtendByAsm(
        success: json["success"],
        message: json["message"],
        result:
            List<ResultAsm>.from(json["result"].map((x) => ResultAsm.fromJson(x))),
      );
}

class ResultAsm {
  ResultAsm({
    this.SalesCode,
    this.SalesName
  });

  String SalesCode;
  String SalesName;

  factory ResultAsm.fromJson(Map<String, dynamic> json) => ResultAsm(
        SalesCode: json["SALES_CODE"],
        SalesName: json["SALES_NAME"]
      );
}
