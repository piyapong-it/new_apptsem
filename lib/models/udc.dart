class Udc {
  Udc({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<UdcResult> result;

  factory Udc.fromJson(Map<String, dynamic> json) => Udc(
    success: json["success"],
    message: json["message"],
    result: List<UdcResult>.from(json["result"].map((x) => UdcResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class UdcResult {
  UdcResult({
    this.udcKey,
    this.udcDesc1,
    this.udcDesc2,
    this.categoryImage,
  });

  String udcKey;
  String udcDesc1;
  String udcDesc2;
  String categoryImage;

  factory UdcResult.fromJson(Map<String, dynamic> json) => UdcResult(
    udcKey: json["UDC_KEY"],
    udcDesc1: json["UDC_DESC1"] == null ? null : json["UDC_DESC1"],
    udcDesc2: json["UDC_DESC2"] == null ? null : json["UDC_DESC2"],
    categoryImage: json["CategoryImage"] == null ? null : json["CategoryImage"],
  );

  Map<String, dynamic> toJson() => {
    "UDC_KEY": udcKey,
    "UDC_DESC1": udcDesc1 == null ? null : udcDesc1,
    "UDC_DESC2": udcDesc2 == null ? null : udcDesc2,
    "CategoryImage": categoryImage == null ? null : categoryImage,
  };
}
