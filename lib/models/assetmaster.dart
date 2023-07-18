class AssetMaster {
  AssetMaster({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<Result> result;

  factory AssetMaster.fromJson(Map<String, dynamic> json) => AssetMaster(
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
    this.stickerId,
    this.outletId,
    this.outletName,
    this.assetCategory,
    this.categoryName,
    this.categoryImage,
    this.assetStatus,
    this.statusNameE,
    this.statusNameT,
    this.assetImage,
    this.assetSno,
    this.assetJdeno,
    this.assetRemark,
    this.assetQuantity,
    this.updateBy,
    this.updateDate,
  });

  String stickerId;
  String outletId;
  String outletName;
  String assetCategory;
  String categoryName;
  String categoryImage;
  String assetStatus;
  String statusNameE;
  String statusNameT;
  String assetImage;
  String assetSno;
  int assetJdeno;
  String assetRemark;
  int assetQuantity;
  String updateBy;
  DateTime updateDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    stickerId: json["STICKER_ID"],
    outletId: json["OutletID"],
    outletName: json["OutletName"],
    assetCategory: json["ASSET_CATEGORY"],
    categoryName: json["CategoryName"],
    categoryImage: json["CategoryImage"] == null ? null : json["CategoryImage"],
    assetStatus: json["ASSET_STATUS"],
    statusNameE: json["StatusNameE"],
    statusNameT: json["StatusNameT"] == null ? null : json["StatusNameT"],
    assetImage: json["ASSET_IMAGE"] == null ? null : json["ASSET_IMAGE"],
    assetSno: json["ASSET_SNO"] == null ? null : json["ASSET_SNO"],
    assetJdeno: json["ASSET_JDENO"] == null ? null : json["ASSET_JDENO"],
    assetRemark: json["ASSET_REMARK"] == null ? null : json["ASSET_REMARK"],
    assetQuantity: json["ASSET_QUANTITY"] == null ? null : json["ASSET_QUANTITY"],
    updateBy: json["UPDATE_BY"] == null ? null : json["UPDATE_BY"],
    updateDate: json["UPDATE_DATE"] == null ? null : DateTime.parse(json["UPDATE_DATE"]),
  );

  Map<String, dynamic> toJson() => {
    "STICKER_ID": stickerId,
    "OutletID": outletId,
    "OutletName": outletName,
    "ASSET_CATEGORY": assetCategory,
    "CategoryName": categoryName,
    "CategoryImage": categoryImage == null ? null : categoryImage,
    "ASSET_STATUS": assetStatus,
    "StatusNameE": statusNameE,
    "StatusNameT": statusNameT == null ? null : statusNameT,
    "ASSET_IMAGE": assetImage == null ? null : assetImage,
    "ASSET_SNO": assetSno == null ? null : assetSno,
    "ASSET_JDENO": assetJdeno == null ? null : assetJdeno,
    "ASSET_REMARK": assetRemark == null ? null : assetRemark,
    "ASSET_QUANTITY": assetQuantity == null ? null : assetQuantity,
    "UPDATE_BY": updateBy == null ? null : updateBy,
    "UPDATE_DATE": updateDate == null ? null : updateDate.toIso8601String(),
  };
}
