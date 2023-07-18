class District {
  District({
    this.success,
    this.message,
    this.result,
  });

  bool success;
  String message;
  List<resDistrict> result;

  factory District.fromJson(Map<String, dynamic> json) => District(
    success: json["success"],
    message: json["message"],
    result: List<resDistrict>.from(json["result"].map((x) => resDistrict.fromJson(x))),
  );
}

class resDistrict {
  resDistrict({
    this.districtId,
    this.districtName,
    this.districtEng,
  });

  String districtId;
  String districtName;
  String districtEng;
 

  factory resDistrict.fromJson(Map<String, dynamic> json) => resDistrict(
    districtId: json["DISTRICT_ID"].toString(),
    districtName: json["DISTRICT_NAME"],
    districtEng: json["DISTRICT_EN"]
  );
}
