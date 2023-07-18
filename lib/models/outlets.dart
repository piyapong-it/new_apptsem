class Outlets {
  Outlets({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory Outlets.fromJson(Map<String, dynamic> json) => Outlets(
    success: json["success"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.outletId,
    this.outletIdnew,
    this.outletName,
    this.address,
    this.city,
    this.province,
    this.zipCode,
    this.gpsLatitude,
    this.gpsLongtitude,
    this.marketsSquare,
    this.telephone,
    this.mobile,
    this.outletTypeId,
    this.outletType,
    this.resultClass,
    this.imagePath,
    this.salesCode,
    this.smId,
    this.salesName,
  });

  String outletId;
  int outletIdnew;
  String outletName;
  String address;
  String city;
  String province;
  String zipCode;
  double gpsLatitude;
  double gpsLongtitude;
  String marketsSquare;
  String telephone;
  String mobile;
  String outletTypeId;
  String outletType;
  String resultClass;
  String imagePath;
  String salesCode;
  String smId;
  String salesName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    outletId: json["OutletID"],
    outletIdnew: json["OutletIDNEW"],
    outletName: json["OutletName"],
    address: json["ADDRESS"],
    city: json["City"],
    province: json["Province"],
    zipCode: json["ZipCode"],
    gpsLatitude: json["GPSLatitude"].toDouble(),
    gpsLongtitude: json["GPSLongtitude"].toDouble(),
    marketsSquare: json["MARKETS_SQUARE"],
    telephone: json["Telephone"],
    mobile: json["Mobile"],
    outletTypeId: json["OutletTypeID"],
    outletType: json["OutletType"],
    resultClass: json["Class"],
    imagePath: json["ImagePath"],
    salesCode: json["SALES_CODE"],
    smId: json["SM_ID"],
    salesName: json["SALES_NAME"],
  );
}
