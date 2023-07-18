class TypeStatus {
  TypeStatus({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<TypeStatusResult> result;

  factory TypeStatus.fromJson(Map<String, dynamic> json) => TypeStatus(
    success: json["success"],
    message: json["message"],
    result: List<TypeStatusResult>.from(json["result"].map((x) => TypeStatusResult.fromJson(x))),
  );

    Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class TypeStatusResult {
  TypeStatusResult({
    this.udc_key,
    this.udc_desc1,
    this.udc_desc2
  });

  String udc_key;
  String udc_desc1;
  String udc_desc2;
 

  factory TypeStatusResult.fromJson(Map<String, dynamic> json) => TypeStatusResult(
    udc_key: json["UDC_KEY"].toString(),
    udc_desc1: json["UDC_DESC1"],
    udc_desc2: json["UDC_DESC2"],
  );

    Map<String, dynamic> toJson() => {
    "UDC_KEY": udc_key,
    "UDC_DESC1": udc_desc1,
    "UDC_DESC2": udc_desc2,
  };
}
