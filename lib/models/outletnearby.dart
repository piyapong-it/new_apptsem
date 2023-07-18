class OutletsNearby {
  OutletsNearby({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory OutletsNearby.fromJson(Map<String, dynamic> json) => OutletsNearby(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.outletId,
    this.outletName,
    this.address,
    this.city,
    this.province,
    this.outletType,
    this.gpsLatitude,
    this.gpsLongtitude,
    this.metre,
  });

  String outletId;
  String outletName;
  String address;
  String city;
  String province;
  String outletType;
  double gpsLatitude;
  double gpsLongtitude;
  int metre;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    address: json["ADDRESS"],
    city: json["City"],
    province: json["Province"],
    outletType: json["OutletType"],
    gpsLatitude: json["GPSLatitude"].toDouble(),
    gpsLongtitude: json["GPSLongtitude"].toDouble(),
    metre: json["Metre"],
  );
}
