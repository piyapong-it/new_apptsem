class OutletDetail {
  OutletDetail({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory OutletDetail.fromJson(Map<String, dynamic> json) => OutletDetail(
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
    this.outletId,
    this.outletName,
    this.address,
    this.city,
    this.province,
    this.zipCode,
    this.gpsLatitude,
    this.gpsLongtitude,
    this.telephone,
    this.mobile,
    this.keyOutlet,
    this.channel,
    this.outletTypeId,
    this.outletType,
    this.grade,
    this.game,
    this.resultClass,
    this.buyFromCode1,
    this.buyFrom1,
    this.saler1Type,
    this.buyFromCode2,
    this.buyFrom2,
    this.saler2Type,
    this.outletImage,
    this.statusDesc,
    this.statusId,
    this.provinceId,
    this.addr1,
    this.addr5,
    this.addr6,
  });

  String outletId;
  String outletName;
  String address;
  String city;
  String province;
  String zipCode;
  double gpsLatitude;
  double gpsLongtitude;
  String telephone;
  String mobile;
  String keyOutlet;
  String channel;
  String outletTypeId;
  String outletType;
  String grade;
  String game;
  String resultClass;
  String buyFromCode1;
  String buyFrom1;
  String saler1Type;
  String buyFromCode2;
  String buyFrom2;
  String saler2Type;
  String outletImage;
  String statusDesc;
  String statusId;
  String provinceId;
  String addr1;
  String addr5;
  String addr6;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    address: json["ADDRESS"],
    city: json["City"],
    province: json["Province"],
    zipCode: json["ZipCode"],
    gpsLatitude: json["GPSLatitude"].toDouble(),
    gpsLongtitude: json["GPSLongtitude"].toDouble(),
    telephone: json["Telephone"],
    mobile: json["Mobile"],
    keyOutlet: json["KeyOutlet"],
    channel: json["Channel"],
    outletTypeId: json["OutletTypeID"],
    outletType: json["OutletType"],
    grade: json["Grade"],
    game: json["GAME"],
    resultClass: json["Class"],
    buyFromCode1: json["BuyFromCode1"],
    buyFrom1: json["BuyFrom1"],
    saler1Type: json["Saler1Type"],
    buyFromCode2: json["BuyFromCode2"],
    buyFrom2: json["BuyFrom2"],
    saler2Type: json["Saler2Type"],
    outletImage: json["OutletImage"],
    statusDesc: json["StatusDesc"],
    statusId: json["StatusId"],
    provinceId: json["ProvinceId"],
    addr1: json["Addr1"],
    addr5: json["Addr5"],
    addr6: json["Addr6"],
  );

  Map<String, dynamic> toJson() => {
    "OutletID": outletId,
    "OutletName": outletName,
    "ADDRESS": address,
    "City": city,
    "Province": province,
    "ZipCode": zipCode,
    "GPSLatitude": gpsLatitude,
    "GPSLongtitude": gpsLongtitude,
    "Telephone": telephone,
    "Mobile": mobile,
    "KeyOutlet": keyOutlet,
    "Channel": channel,
    "OutletTypeID": outletTypeId,
    "OutletType": outletType,
    "Grade": grade,
    "GAME": game,
    "Class": resultClass,
    "BuyFromCode1": buyFromCode1,
    "BuyFrom1": buyFrom1,
    "Saler1Type": saler1Type,
    "BuyFromCode2": buyFromCode2,
    "BuyFrom2": buyFrom2,
    "Saler2Type": saler2Type,
    "OutletImage": outletImage,
    "StatusDesc": statusDesc,
    "StatusId": statusId,
    "ProvinceId": provinceId,
    "Addr1": addr1,
    "Addr5": addr5,
    "Addr6": addr6,
  };
}
