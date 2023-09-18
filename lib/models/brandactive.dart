class BrandActive {
  BrandActive({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<resBrandActive> result;

  factory BrandActive.fromJson(Map<String, dynamic> json) => BrandActive(
        success: json["success"],
        message: json["message"],
        result: List<resBrandActive>.from(
            json["result"].map((x) => resBrandActive.fromJson(x))),
      );
}

class resBrandActive {
  resBrandActive({
    this.bmId,
    this.bmName,
  });
  final int bmId;
  final String bmName;

  factory resBrandActive.fromJson(Map<String, dynamic> json) => resBrandActive(
        bmId: json["BM_ID"],
        bmName: json["BM_NAME"],
      );
}
