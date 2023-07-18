class SubDistrict {
  SubDistrict({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<resSubDistrict> result;

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
    success: json["success"],
    message: json["message"],
    result: List<resSubDistrict>.from(json["result"].map((x) => resSubDistrict.fromJson(x))),
  );
}

class resSubDistrict {
  resSubDistrict({
    this.subdistrictId,
    this.subdistrictName,
    this.subdistrictEng,
    this.zipCode,
  });

  String subdistrictId;
  String subdistrictName;
  String subdistrictEng;
  String zipCode;
 

  factory resSubDistrict.fromJson(Map<String, dynamic> json) => resSubDistrict(
    subdistrictId: json["SUBDISTRICT_ID"].toString(),
    subdistrictName: json["SUBDISTRICT_NAME"],
    subdistrictEng: json["SUBDISTRICT_EN"],
    zipCode: json["ZIP_CODE"].toString()
  );
}
